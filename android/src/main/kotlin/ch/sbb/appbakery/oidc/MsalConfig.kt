package ch.sbb.appbakery.oidc

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.security.MessageDigest

data class MsalConfig(
    val tenantId: String,
    val clientId: String,
    val redirectUri: String,
) {

    val endSessionUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/logout"

    suspend fun writeToFile(context: Context): File {
        val configJson = createConfigJson()
        val configHash = configJson.md5()
        val dir = File(context.noBackupFilesDir, "sbb_oidc")
        if (!dir.exists()) {
            dir.mkdirs()
        }
        val file = File(dir, "msal_config_$configHash.json")
        if (!file.exists()) {
            file.writeText(configJson, Charsets.UTF_8)
        }
        return file
    }

    private fun createConfigJson(): String {
        return JSONObject().apply {
            put("client_id", clientId)
            put("redirect_uri", redirectUri)
            put("authorities", JSONArray().apply {
                put(JSONObject().apply {
                    put("type", "AAD")
                    put("audience", JSONObject().apply {
                        put("type", "AzureADMyOrg")
                        put("tenant_id", tenantId)
                    })
                    put("authority_url", "https://login.microsoftonline.com/$tenantId")
                    put("default", true)
                })
            })
            put("logcat_enabled", true)
            put("log_level", "VERBOSE")
            put("pii_enabled", true)
        }.toString()
    }
}

private fun String.md5(): String {
    val input = toByteArray()
    val digest = MessageDigest.getInstance("MD5")
    val hashValue = digest.digest(input)
    return hashValue.toHexString(format = HexFormat.UpperCase)
}