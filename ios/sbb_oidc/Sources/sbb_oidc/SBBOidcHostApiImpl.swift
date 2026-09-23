import Foundation
import MSAL
import UIKit

class SBBOidcHostApiImpl: NSObject, SBBOidcHostApi {

    private static let currentAccountIdKey = "ch.sbb.oidc.current_account_id"

    private let defaults = UserDefaults.standard
    private var pca: MSALPublicClientApplication?

    func initialize(parameters: InitializeParameters) async throws {
        do {
            let config = MSALPublicClientApplicationConfig(
                clientId: parameters.clientId,
                redirectUri: parameters.redirectUri,
                authority: parameters.authority,
            )
            config.bypassRedirectURIValidation = true
            config.cacheConfig.keychainSharingGroup = parameters.keychainAccessGroup
            self.pca = try MSALPublicClientApplication(configuration: config)
        } catch {
            throw error.toPigeonError(
                message: "MSAL public client application initialization failed"
            )
        }
    }

    @MainActor
    func login(parameters: LoginParameters) async throws -> OidcTokenResponse {
        let pca = try pcaOrThrow()
        guard let viewController = currentViewController() else {
            throw PigeonError(
                code: "no_view_controller_attached",
                message: nil,
                details: nil
            )
        }
        let webviewParameters = MSALWebviewParameters(
            authPresentationViewController: viewController
        )
        let interactiveTokenParameters = MSALInteractiveTokenParameters(
            scopes: parameters.scopes.removeReserved(),
            webviewParameters: webviewParameters
        )
        interactiveTokenParameters.loginHint = parameters.loginHint
        interactiveTokenParameters.promptType =
            parameters.prompt?.toMSALPromptType() ?? .default
        return try await withCheckedThrowingContinuation { continuation in
            pca.acquireToken(with: interactiveTokenParameters) {
                result,
                error in
                if let error {
                    if (error as NSError).isUserCancelled {
                        let e = PigeonError(
                            code: "login_canceled",
                            message: nil,
                            details: nil
                        )
                        continuation.resume(throwing: e)
                    } else {
                        let e = error.toPigeonError(message: "Login failed")
                        continuation.resume(throwing: e)
                    }
                    return
                }
                guard let result else {
                    let e = PigeonError(
                        code: "login_failed",
                        message: nil,
                        details: nil
                    )
                    continuation.resume(throwing: e)
                    return
                }
                self.defaults.set(
                    result.account.identifier,
                    forKey: Self.currentAccountIdKey
                )
                continuation.resume(returning: result.toOidcTokenResponse())
            }
        }
    }

    func getToken(parameters: GetTokenParameters) async throws
        -> OidcTokenResponse
    {
        let pca = try pcaOrThrow()
        guard let account = try currentAccount(pca) else {
            throw PigeonError(
                code: "no_current_account",
                message: nil,
                details: nil
            )
        }
        let silentTokenParameters = MSALSilentTokenParameters(
            scopes: parameters.scopes.removeReserved(),
            account: account
        )
        silentTokenParameters.forceRefresh = parameters.forceRefresh
        return try await withCheckedThrowingContinuation { continuation in
            pca.acquireTokenSilent(with: silentTokenParameters) {
                result,
                error in
                if let error {
                    continuation.resume(throwing: error.toPigeonError())
                    return
                }
                guard let result else {
                    let e = PigeonError(
                        code: "get_token_failed",
                        message: nil,
                        details: nil
                    )
                    continuation.resume(throwing: e)
                    return
                }
                continuation.resume(returning: result.toOidcTokenResponse())
            }
        }
    }

    func logout() async throws {
        let pca = try pcaOrThrow()
        guard let account = try currentAccount(pca) else { return }
        do {
            try pca.remove(account)
            defaults.removeObject(forKey: Self.currentAccountIdKey)
        } catch {
            throw error.toPigeonError()
        }
    }

    @MainActor
    func endSession() async throws {
        let pca = try pcaOrThrow()
        guard let account = try currentAccount(pca) else { return }
        guard let viewController = currentViewController() else {
            throw PigeonError(
                code: "no_view_controller_attached",
                message: nil,
                details: nil
            )
        }
        let webviewParameters = MSALWebviewParameters(
            authPresentationViewController: viewController
        )
        let signoutParameters = MSALSignoutParameters(
            webviewParameters: webviewParameters
        )
        // Signs the account out of the browser session too, not just the local MSAL cache.
        signoutParameters.signoutFromBrowser = true
        try await withCheckedThrowingContinuation { continuation in
            pca.signout(with: account, signoutParameters: signoutParameters) {
                success,
                error in
                if success && error == nil {
                    self.defaults.removeObject(forKey: Self.currentAccountIdKey)
                    continuation.resume()
                    return
                }
                if let error {
                    let e = error.toPigeonError()
                    continuation.resume(throwing: e)
                } else {
                    let e = PigeonError(
                        code: "end_session_failed",
                        message: nil,
                        details: nil
                    )
                    continuation.resume(throwing: e)
                }
            }
        }
    }

    // MARK: - MSAL redirect handling

    func handleOpen(
        url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        MSALPublicClientApplication.handleMSALResponse(
            url,
            sourceApplication: options[.sourceApplication] as? String
        )
    }

    // MARK: - Helpers

    private func pcaOrThrow() throws -> MSALPublicClientApplication {
        guard let pca else {
            throw PigeonError(
                code: "not_initialized",
                message: nil,
                details: nil
            )
        }
        return pca
    }

    private func currentAccount(_ pca: MSALPublicClientApplication) throws
        -> MSALAccount?
    {
        guard
            let currentAccountId = defaults.string(
                forKey: Self.currentAccountIdKey
            )
        else {
            return nil
        }
        do {
            return try pca.account(forIdentifier: currentAccountId)
        } catch {
            throw error.toPigeonError()
        }
    }

    private func currentViewController() -> UIViewController? {
        let rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        return topViewController(of: rootViewController)
    }

    private func topViewController(of viewController: UIViewController?)
        -> UIViewController?
    {
        switch viewController {
        case let navigationController as UINavigationController:
            return topViewController(
                of: navigationController.visibleViewController
            )
        case let tabBarController as UITabBarController:
            return topViewController(
                of: tabBarController.selectedViewController
            )
        case let presenting where presenting?.presentedViewController != nil:
            return topViewController(of: presenting?.presentedViewController)
        default:
            return viewController
        }
    }
}

// MARK: - Extensions

extension InitializeParameters {
    fileprivate let authority: MSALAADAuthority {
        let url = URL(
            string:
                "https://login.microsoftonline.com/\(parameters.tenantId)"
        )!
        return MSALAADAuthority(url: url)
    }
}

extension String {
    fileprivate func toMSALPromptType() -> MSALPromptType {
        switch self {
        case "consent": return .consent
        case "login": return .login
        case "none": return .promptIfNecessary
        case "select_account": return .selectAccount
        default: return .default
        }
    }
}

extension MSALResult {
    fileprivate func toOidcTokenResponse() -> OidcTokenResponse {
        OidcTokenResponse(
            accessToken: accessToken,
            authenticationScheme: authenticationScheme,
            expiresOn: expiresOn!.ISO8601Format(),
            idToken: idToken!,
        )
    }
}

extension NSError {
    fileprivate var isUserCancelled: Bool {
        domain == MSALErrorDomain && code == MSALError.userCanceled.rawValue
    }
}

extension Error {
    fileprivate func toPigeonError(message: String? = nil) -> PigeonError {
        let nsError = self as NSError
        let subErrorCode = nsError.userInfo["MSALOAuthSubErrorKey"] as? String
        let code: String =
            if let subErrorCode, !subErrorCode.isEmpty {
                "\(nsError.domain).\(nsError.code) :: \(subErrorCode)"
            } else {
                "\(nsError.domain).\(nsError.code)"
            }
        let underlyingMessage =
            nsError.userInfo["MSALErrorDescriptionKey"] as? String
            ?? nsError.localizedDescription
        let fullMessage =
            message.map { "\($0) :: \(underlyingMessage)" } ?? underlyingMessage
        return PigeonError(code: code, message: fullMessage, details: nsError)
    }
}

extension [String] {
    fileprivate func removeReserved() -> [String] {
        let reservedScopes: Set<String> = [
            "openid",
            "profile",
            "offline_access",
        ]
        return filter { !reservedScopes.contains($0) }
    }
}
