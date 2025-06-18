package com.example.flutter_kinescope_player

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.kinescope.sdk.view.KinescopePlayerView
import io.kinescope.sdk.player.KinescopeVideoPlayer
import io.kinescope.sdk.player.KinescopePlayerOptions

class KinescopePlayerViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    
    companion object {
        private const val TAG = "KinescopePlayerFactory"
        private var nextViewId = 1
        private val players = mutableMapOf<Int, KinescopeVideoPlayer>()
        private val playerViews = mutableMapOf<Int, KinescopePlayerView>()
        
        fun createViewId(): Int {
            return nextViewId++
        }
        
        fun initializePlayer(viewId: Int, config: Map<String, Any>?, result: MethodChannel.Result) {
            Log.d(TAG, "Initializing player for viewId: $viewId")
            Log.d(TAG, "Available players before init: ${players.keys}")
            
            val player = players[viewId]
            if (player != null) {
                try {
                    // Применяем конфигурацию к плееру
                    config?.let { cfg ->
                        // Применяем настройки из конфигурации
                        Log.d(TAG, "Applying config: $cfg")
                        
                        // Применяем referer
                        val referer = cfg["referer"] as? String
                        if (referer != null) {
                            player.setReferer(referer)
                        }
                        
                        // Применяем настройки UI
                        val showFullscreenButton = cfg["showFullscreenButton"] as? Boolean
                        if (showFullscreenButton != null) {
                            player.setShowFullscreen(showFullscreenButton)
                        }
                        
                        val showOptionsButton = cfg["showOptionsButton"] as? Boolean
                        if (showOptionsButton != null) {
                            player.setShowOptions(showOptionsButton)
                        }
                        
                        val showSubtitlesButton = cfg["showSubtitlesButton"] as? Boolean
                        if (showSubtitlesButton != null) {
                            player.setShowSubtitles(showSubtitlesButton)
                        }
                        
                        // Применяем DRM токен если есть
                        val drmToken = cfg["drmToken"] as? Map<String, Any>
                        if (drmToken != null) {
                            val licenseUrl = drmToken["licenseUrl"] as? String
                            val token = drmToken["token"] as? String
                            
                            if (licenseUrl != null && token != null) {
                                Log.d(TAG, "Applying DRM token: licenseUrl=$licenseUrl")
                                // Здесь нужно будет применить DRM токен к плееру
                                // Это зависит от реализации KinescopeVideoPlayer
                            }
                        }
                    }
                    
                    Log.d(TAG, "Player found for viewId: $viewId, initialization successful")
                    try {
                        result.success(mapOf("success" to true))
                    } catch (e: Exception) {
                        Log.e(TAG, "Error sending init success result", e)
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Exception during player initialization", e)
                    try {
                        result.error("INIT_ERROR", e.message, null)
                    } catch (ex: Exception) {
                        Log.e(TAG, "Error sending init exception result", ex)
                    }
                }
            } else {
                Log.e(TAG, "Player not found for viewId: $viewId during initialization")
                try {
                    result.error("PLAYER_NOT_FOUND", "Player not found for viewId: $viewId", null)
                } catch (e: Exception) {
                    Log.e(TAG, "Error sending init player not found result", e)
                }
            }
        }
        
        fun loadVideo(viewId: Int, videoId: String, result: MethodChannel.Result) {
            Log.d(TAG, "Loading video: $videoId for viewId: $viewId")
            Log.d(TAG, "Available players: ${players.keys}")
            
            val player = players[viewId]
            if (player != null) {
                Log.d(TAG, "Player found, attempting to load video")
                try {
                    player.loadVideo(videoId,
                        onSuccess = { video ->
                            Log.d(TAG, "Video loaded successfully: "+(video?.title ?: "Unknown title"))
                            try {
                                result.success(mapOf(
                                    "success" to true,
                                    "title" to video?.title,
                                    "duration" to video?.duration
                                ))
                            } catch (e: Exception) {
                                Log.e(TAG, "Error sending success result", e)
                            }
                        },
                        onFailed = { error ->
                            Log.e(TAG, "Failed to load video: "+(error?.message ?: "Unknown error"))
                            try {
                                result.error("LOAD_ERROR", error?.message ?: "Failed to load video", null)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error sending error result", e)
                            }
                        }
                    )
                    Log.d(TAG, "loadVideo method called successfully")
                } catch (e: Exception) {
                    Log.e(TAG, "Exception while loading video", e)
                    try {
                        result.error("LOAD_ERROR", e.message, null)
                    } catch (ex: Exception) {
                        Log.e(TAG, "Error sending exception result", ex)
                    }
                }
            } else {
                Log.e(TAG, "Player not found for viewId: $viewId")
                try {
                    result.error("PLAYER_NOT_FOUND", "Player not found for viewId: $viewId", null)
                } catch (e: Exception) {
                    Log.e(TAG, "Error sending player not found result", e)
                }
            }
        }
        
        fun play(viewId: Int, result: MethodChannel.Result) {
            Log.d(TAG, "Playing video for viewId: $viewId")
            val player = players[viewId]
            if (player != null) {
                try {
                    player.play()
                    result.success(null)
                } catch (e: Exception) {
                    Log.e(TAG, "Exception while playing", e)
                    result.error("PLAY_EXCEPTION", e.message, null)
                }
            } else {
                result.error("PLAYER_NOT_FOUND", "Player not found for viewId: $viewId", null)
            }
        }
        
        fun pause(viewId: Int, result: MethodChannel.Result) {
            Log.d(TAG, "Pausing video for viewId: $viewId")
            val player = players[viewId]
            if (player != null) {
                try {
                    Log.d(TAG, "Calling player.pause() for viewId: $viewId")
                    player.pause()
                    Log.d(TAG, "player.pause() called successfully for viewId: $viewId")
                    result.success(null)
                } catch (e: Exception) {
                    Log.e(TAG, "Exception while pausing", e)
                    result.error("PAUSE_EXCEPTION", e.message, null)
                }
            } else {
                result.error("PLAYER_NOT_FOUND", "Player not found for viewId: $viewId", null)
            }
        }
        
        fun seekTo(viewId: Int, position: Int, result: MethodChannel.Result) {
            Log.d(TAG, "Seeking to position: $position for viewId: $viewId")
            val player = players[viewId]
            if (player != null) {
                try {
                    player.seekTo(position.toLong())
                    result.success(null)
                } catch (e: Exception) {
                    Log.e(TAG, "Exception while seeking", e)
                    result.error("SEEK_EXCEPTION", e.message, null)
                }
            } else {
                result.error("PLAYER_NOT_FOUND", "Player not found for viewId: $viewId", null)
            }
        }
        
        fun setFullscreen(viewId: Int, fullscreen: Boolean, result: MethodChannel.Result) {
            Log.d(TAG, "Setting fullscreen: $fullscreen for viewId: $viewId")
            val playerView = playerViews[viewId]
            if (playerView != null) {
                // Здесь должна быть логика переключения полноэкранного режима
                // В реальной реализации нужно будет создать отдельную Activity для полноэкранного режима
                result.success(null)
            } else {
                result.error("PLAYER_VIEW_NOT_FOUND", "Player view not found for viewId: $viewId", null)
            }
        }
        
        fun dispose(viewId: Int, result: MethodChannel.Result) {
            Log.d(TAG, "Disposing player for viewId: $viewId")
            val player = players[viewId]
            if (player != null) {
                try {
                    // KinescopeVideoPlayer не имеет метода release, просто очищаем ссылку
                    Log.d(TAG, "Clearing player reference for viewId: $viewId")
                } catch (e: Exception) {
                    Log.w(TAG, "Exception while disposing player", e)
                }
                players.remove(viewId)
            }
            
            val playerView = playerViews[viewId]
            if (playerView != null) {
                playerViews.remove(viewId)
            }
            
            result.success(null)
        }
        
        fun forceReleaseAllPlayers() {
            Log.d(TAG, "Force releasing all players")
            try {
                // Останавливаем и освобождаем все плееры
                players.forEach { (viewId, player) ->
                    try {
                        Log.d(TAG, "Force releasing player for viewId: $viewId")
                        player.pause()
                        // Если у плеера есть метод release, вызываем его
                        // player.release()
                    } catch (e: Exception) {
                        Log.w(TAG, "Exception while force releasing player for viewId: $viewId", e)
                    }
                }
                
                // Очищаем все коллекции
                players.clear()
                playerViews.clear()
                
                Log.d(TAG, "All players force released successfully")
            } catch (e: Exception) {
                Log.e(TAG, "Exception while force releasing all players", e)
            }
        }
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d(TAG, "Creating platform view for viewId: $viewId")
        Log.d(TAG, "Creation params: $args")
        val creationParams = args as? Map<String?, Any?>
        
        try {
            // Создаем KinescopePlayerView с правильным конструктором
            val playerView = KinescopePlayerView(context, null)
            Log.d(TAG, "KinescopePlayerView created successfully")
            
            // Создаем KinescopeVideoPlayer с опциями
            val playerOptions = KinescopePlayerOptions()
            
            // Применяем конфигурацию из creationParams
            creationParams?.let { params ->
                val config = params["config"] as? Map<String, Any>
                config?.let { cfg ->
                    // Применяем referer
                    val referer = cfg["referer"] as? String
                    if (referer != null) {
                        playerOptions.referer = referer
                    }
                    
                    // Применяем настройки UI
                    val showFullscreenButton = cfg["showFullscreenButton"] as? Boolean
                    if (showFullscreenButton != null) {
                        playerOptions.showFullscreenButton = showFullscreenButton
                    }
                    
                    val showOptionsButton = cfg["showOptionsButton"] as? Boolean
                    if (showOptionsButton != null) {
                        playerOptions.showOptionsButton = showOptionsButton
                    }
                    
                    val showSubtitlesButton = cfg["showSubtitlesButton"] as? Boolean
                    if (showSubtitlesButton != null) {
                        playerOptions.showSubtitlesButton = showSubtitlesButton
                    }
                    
                    val showSeekBar = cfg["showSeekBar"] as? Boolean
                    if (showSeekBar != null) {
                        playerOptions.showSeekBar = showSeekBar
                    }
                    
                    val showDuration = cfg["showDuration"] as? Boolean
                    if (showDuration != null) {
                        playerOptions.showDuration = showDuration
                    }
                    
                    val showAttachments = cfg["showAttachments"] as? Boolean
                    if (showAttachments != null) {
                        playerOptions.showAttachments = showAttachments
                    }
                }
            }
            
            val player = KinescopeVideoPlayer(context, playerOptions)
            Log.d(TAG, "KinescopeVideoPlayer created successfully")
            
            // Устанавливаем плеер в view
            playerView.setPlayer(player)
            Log.d(TAG, "Player set to view successfully")
            
            // Сохраняем ссылки СРАЗУ при создании
            players[viewId] = player
            playerViews[viewId] = playerView
            Log.d(TAG, "Player and view saved for viewId: $viewId")
            Log.d(TAG, "Current players map: ${players.keys}")
            
            return object : PlatformView {
                override fun getView(): KinescopePlayerView {
                    Log.d(TAG, "getView() called for viewId: $viewId")
                    return playerView
                }
                
                override fun dispose() {
                    Log.d(TAG, "Disposing platform view for viewId: $viewId")
                    dispose(viewId, object : MethodChannel.Result {
                        override fun success(result: Any?) {}
                        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                            Log.e(TAG, "Error during dispose: $errorCode - $errorMessage")
                        }
                        override fun notImplemented() {}
                    })
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Exception while creating platform view", e)
            throw e
        }
    }
} 