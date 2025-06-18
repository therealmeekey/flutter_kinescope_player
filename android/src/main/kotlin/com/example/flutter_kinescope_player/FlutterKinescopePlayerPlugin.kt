package com.example.flutter_kinescope_player

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.platform.PlatformViewRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** FlutterKinescopePlayerPlugin */
class FlutterKinescopePlayerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the FlutterEngine and unregister it
    /// when the FlutterEngine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var drmChannel: MethodChannel
//    private var drmHelper: KinescopeDrmHelper? = null
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_kinescope_player")
        channel.setMethodCallHandler(this)

        drmChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_kinescope_player_drm")
        drmChannel.setMethodCallHandler(this)

        // Регистрируем фабрику для создания нативных view
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("flutter_kinescope_player_view", KinescopePlayerViewFactory())
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initializePlayer" -> {
                val viewId = call.argument<Int>("viewId")
                val config = call.argument<Map<String, Any>>("config")

                if (viewId != null) {
                    KinescopePlayerViewFactory.initializePlayer(viewId, config, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "viewId is required", null)
                }
            }

            "loadVideo" -> {
                val viewId = call.argument<Int>("viewId")
                val videoId = call.argument<String>("videoId")
                if (viewId != null && videoId != null) {
                    KinescopePlayerViewFactory.loadVideo(viewId, videoId, result)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId and videoId are required", null)
                }
            }

            "play" -> {
                val viewId = call.argument<Int>("viewId")
                if (viewId != null) {
                    KinescopePlayerViewFactory.play(viewId, result)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId is required", null)
                }
            }

            "pause" -> {
                val viewId = call.argument<Int>("viewId")
                if (viewId != null) {
                    KinescopePlayerViewFactory.pause(viewId, result)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId is required", null)
                }
            }

            "seekTo" -> {
                val viewId = call.argument<Int>("viewId")
                val position = call.argument<Int>("position")
                if (viewId != null && position != null) {
                    KinescopePlayerViewFactory.seekTo(viewId, position, result)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId and position are required", null)
                }
            }

            "setFullscreen" -> {
                val viewId = call.argument<Int>("viewId")
                val fullscreen = call.argument<Boolean>("fullscreen")
                if (viewId != null && fullscreen != null) {
                    KinescopePlayerViewFactory.setFullscreen(viewId, fullscreen, result)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId and fullscreen are required", null)
                }
            }

            "dispose" -> {
                val viewId = call.argument<Int>("viewId")
                if (viewId != null) {
                    KinescopePlayerViewFactory.dispose(viewId, result)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId is required", null)
                }
            }

//            "getPlatformVersion" -> {
//                result.success("Android ${android.os.Build.VERSION.RELEASE}")
//            }
//
//            "getDrmTokenViaWebView" -> {
//                val videoId = call.argument<String>("videoId")
//                val domainUrl = call.argument<String>("domainUrl")
//
//                if (videoId != null && domainUrl != null) {
//                    if (context == null) {
//                        result.error("CONTEXT_ERROR", "Context is null", null)
//                        return
//                    }
//
//                    CoroutineScope(Dispatchers.Main).launch {
//                        try {
//                            val drmHelper = KinescopeDrmHelper(context!!)
//                            val drmData = drmHelper.getDrmTokenViaWebView(videoId, domainUrl)
//
//                            if (drmData != null) {
//                                val resultMap = mapOf(
//                                    "licenseUrl" to drmData.licenseUrl,
//                                    "token" to drmData.token
//                                )
//                                result.success(resultMap)
//                            } else {
//                                result.error("DRM_ERROR", "Не удалось получить DRM токен", null)
//                            }
//                        } catch (e: Exception) {
//                            result.error(
//                                "DRM_ERROR",
//                                "Ошибка получения DRM токена на Android: ${e.message}",
//                                null
//                            )
//                        }
//                    }
//                } else {
//                    result.error("INVALID_ARGUMENTS", "Неверные аргументы", null)
//                }
//            }

            "forceReleaseAllPlayers" -> {
                try {
                    // Принудительно освобождаем все ресурсы плеера
                    KinescopePlayerViewFactory.forceReleaseAllPlayers()
                    result.success(true)
                } catch (e: Exception) {
                    result.error(
                        "RELEASE_ERROR",
                        "Ошибка освобождения ресурсов: ${e.message}",
                        null
                    )
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        drmChannel.setMethodCallHandler(null)
        context = null
    }
} 