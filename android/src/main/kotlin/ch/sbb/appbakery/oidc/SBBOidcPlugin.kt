package ch.sbb.appbakery.oidc

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class SBBOidcPlugin : FlutterPlugin, ActivityAware {

    private var api: SBBOidcHostApiImpl? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (api == null) {
            api = SBBOidcHostApiImpl(
                context = binding.applicationContext,
            )
        }
        SBBOidcHostApi.setUp(
            binaryMessenger = binding.binaryMessenger,
            api = api,
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        api = null
        SBBOidcHostApi.setUp(
            binaryMessenger = binding.binaryMessenger,
            api = null,
        )
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        api?.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        api?.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        api?.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        api?.activity = null
    }
}
