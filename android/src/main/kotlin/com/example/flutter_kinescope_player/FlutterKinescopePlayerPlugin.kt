package com.example.flutter_kinescope_player

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

/** FlutterKinescopePlayerPlugin */
class FlutterKinescopePlayerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the FlutterEngine and unregister it
  /// when the FlutterEngine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_kinescope_player")
    channel.setMethodCallHandler(this)
    
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
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
} 