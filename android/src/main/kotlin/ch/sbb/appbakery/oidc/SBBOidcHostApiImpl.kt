package ch.sbb.appbakery.oidc

import android.app.Activity
import android.content.Context
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.content.edit
import androidx.core.net.toUri
import com.microsoft.identity.client.AcquireTokenParameters
import com.microsoft.identity.client.AcquireTokenSilentParameters
import com.microsoft.identity.client.AuthenticationCallback
import com.microsoft.identity.client.IAccount
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.IMultipleAccountPublicClientApplication
import com.microsoft.identity.client.IPublicClientApplication
import com.microsoft.identity.client.IPublicClientApplication.IMultipleAccountApplicationCreatedListener
import com.microsoft.identity.client.Prompt
import com.microsoft.identity.client.PublicClientApplication
import com.microsoft.identity.client.SilentAuthenticationCallback
import com.microsoft.identity.client.exception.MsalClientException
import com.microsoft.identity.client.exception.MsalException
import kotlinx.coroutines.suspendCancellableCoroutine
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class SBBOidcHostApiImpl(
    private val context: Context,
) : SBBOidcHostApi {

    var activity: Activity? = null
    private lateinit var pca: IMultipleAccountPublicClientApplication
    private val prefs = context.getSharedPreferences("sbb_oidc", Context.MODE_PRIVATE)
    private lateinit var clientId: String
    private lateinit var tenantId: String

    override suspend fun initialize(parameters: InitializeParameters) {
        val config = MsalConfig(
            tenantId = parameters.tenantId,
            clientId = parameters.clientId,
            redirectUri = parameters.redirectUri,
        )
        val configFile = config.writeToFile(context)
        return suspendCancellableCoroutine { continuation ->
            val listener = object : IMultipleAccountApplicationCreatedListener {
                override fun onCreated(application: IMultipleAccountPublicClientApplication) {
                    pca = application
                    clientId = parameters.clientId
                    tenantId = parameters.tenantId
                    continuation.resume(Unit)
                }

                override fun onError(exception: MsalException) {
                    val e = exception.toFlutterError(
                        message = "MSAL public client application initialization failed",
                    )
                    continuation.resumeWithException(e)
                }
            }
            PublicClientApplication.createMultipleAccountPublicClientApplication(
                context,
                configFile,
                listener,
            )
        }
    }

    override suspend fun login(parameters: LoginParameters): OidcTokenResponse {
        val activity = this.activity ?: throw FlutterError(code = "no_activity_attached")
        return suspendCancellableCoroutine { continuation ->
            val callback = object : AuthenticationCallback {
                override fun onCancel() {
                    val e = FlutterError(code = "login_canceled")
                    continuation.resumeWithException(e)
                }

                override fun onSuccess(authenticationResult: IAuthenticationResult) {
                    val account = authenticationResult.account
                    prefs.edit {
                        putString(CURRENT_ACCOUNT_ID_KEY, account.accountId)
                        apply()
                    }
                    val response = authenticationResult.toOidcTokenResponse()
                    continuation.resume(response)
                }

                override fun onError(exception: MsalException) {
                    val e = exception.toFlutterError(message = "Login failed")
                    continuation.resumeWithException(e)
                }
            }
            val acquireTokenParameters = AcquireTokenParameters.Builder()
                .startAuthorizationFromActivity(activity)
                .withScopes(parameters.scopes)
                .withPrompt(parameters.prompt?.toPrompt())
                .withLoginHint(parameters.loginHint)
                .withCallback(callback)
                .build()
            pca.acquireToken(acquireTokenParameters)
        }
    }

    override suspend fun getToken(parameters: GetTokenParameters): OidcTokenResponse {
        val account = currentAccount() ?: throw FlutterError(
            code = MsalClientException.NO_CURRENT_ACCOUNT,
            message = MsalClientException.NO_CURRENT_ACCOUNT_ERROR_MESSAGE,
        )
        return suspendCancellableCoroutine { continuation ->
            val callback = object : SilentAuthenticationCallback {
                override fun onSuccess(authenticationResult: IAuthenticationResult) {
                    val response = authenticationResult.toOidcTokenResponse()
                    continuation.resume(response)
                }

                override fun onError(exception: MsalException) {
                    val e = exception.toFlutterError()
                    continuation.resumeWithException(e)
                }
            }
            val acquireTokenSilentParameters = AcquireTokenSilentParameters.Builder()
                .withScopes(parameters.scopes)
                .forAccount(account)
                .forceRefresh(parameters.forceRefresh)
                .fromAuthority(account.authority)
                .withCallback(callback)
                .build()
            pca.acquireTokenSilentAsync(acquireTokenSilentParameters)
        }
    }

    override suspend fun logout() {
        val account = currentAccount() ?: return
        return suspendCancellableCoroutine { continuation ->
            val callback = object : IMultipleAccountPublicClientApplication.RemoveAccountCallback {
                override fun onRemoved() {
                    prefs.edit {
                        remove(CURRENT_ACCOUNT_ID_KEY)
                        apply()
                    }
                    continuation.resume(Unit)
                }

                override fun onError(exception: MsalException) {
                    val fe = exception.toFlutterError()
                    continuation.resumeWithException(fe)
                }
            }
            pca.removeAccount(account, callback)
        }
    }

    override suspend fun endSession() {
        // https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc#send-a-sign-out-request
        val activity = this.activity ?: throw FlutterError(code = "no_activity_attached")
        val account = currentAccount() ?: return
        val endSessionUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/logout"
            .toUri()
            .buildUpon().apply {
                // Important: do not add post_logout_redirect_uri to the end session URL. When this
                // parameter is included, the request can fail with error AADSTS90023. Entra ID
                // shows its default post-sign-out page to the user if post_logout_redirect_uri is
                // omitted.
                val loginHint = account.claims?.get("login_hint") as String?
                if (!loginHint.isNullOrBlank()) {
                    appendQueryParameter("logout_hint", loginHint)
                }
            }
            .build()
        val intent = CustomTabsIntent.Builder().build()
        intent.launchUrl(activity, endSessionUrl)
        logout()
    }

    private suspend fun currentAccount(): IAccount? {
        val currentAccountId = prefs.getString(CURRENT_ACCOUNT_ID_KEY, null) ?: return null
        val accounts = accounts()
        return accounts.firstOrNull { account ->
            account.accountId == currentAccountId
        }
    }

    private suspend fun accounts(): List<IAccount> {
        return suspendCancellableCoroutine { continuation ->
            val callback = object : IPublicClientApplication.LoadAccountsCallback {
                override fun onTaskCompleted(result: List<IAccount>) {
                    continuation.resume(result)
                }

                override fun onError(exception: MsalException) {
                    val e = exception.toFlutterError()
                    continuation.resumeWithException(e)
                }

            }
            pca.getAccounts(callback)
        }
    }

    private companion object {
        const val CURRENT_ACCOUNT_ID_KEY = "current_account_id"
    }
}

private val IAccount.accountId: String get() = "$id.$tenantId"

private fun String.toPrompt(): Prompt? {
    return try {
        Prompt.valueOf(this)
    } catch (_: Throwable) {
        null
    }
}

private fun IAuthenticationResult.toOidcTokenResponse(): OidcTokenResponse {
    return OidcTokenResponse(
        accessToken = accessToken,
        authenticationScheme = authenticationScheme,
        expiresOn = expiresOn.toIso8601String(),
        idToken = account.idToken!!,
    )
}

private fun Date.toIso8601String(): String {
    val format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
    format.timeZone = TimeZone.getTimeZone("UTC")
    return format.format(this)
}

private fun MsalException.toFlutterError(message: String? = null): FlutterError {
    return FlutterError(
        code = when (subErrorCode.isNullOrBlank()) {
            false -> "$errorCode :: $subErrorCode"
            else -> errorCode
        },
        message = when (message.isNullOrBlank()) {
            false -> "$message :: ${this.message}"
            else -> this.message
        },
        details = this,
    )
}
