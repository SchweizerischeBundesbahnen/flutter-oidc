import Flutter
import UIKit

public class SBBOidcPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate {
    private let api = SBBOidcHostApiImpl()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SBBOidcPlugin()
        SBBOidcHostApiSetup.setUp(
            binaryMessenger: registrar.messenger(),
            api: instance.api
        )
        // MSAL needs to see the redirect URL that iOS forwards to the app delegate.
        registrar.addApplicationDelegate(instance)
    }

    public func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        api.handleOpen(url: url, options: options)
    }
}
