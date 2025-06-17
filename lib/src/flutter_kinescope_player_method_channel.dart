import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_kinescope_player_platform_interface.dart';

/// An implementation of [FlutterKinescopePlayerPlatform] that uses method channels.
class MethodChannelFlutterKinescopePlayer extends FlutterKinescopePlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_kinescope_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initializePlayer(int viewId) async {
    await methodChannel.invokeMethod('initializePlayer', {'viewId': viewId});
  }

  @override
  Future<void> loadVideo(int viewId, String videoId) async {
    await methodChannel.invokeMethod('loadVideo', {
      'viewId': viewId,
      'videoId': videoId,
    });
  }

  @override
  Future<void> play(int viewId) async {
    await methodChannel.invokeMethod('play', {'viewId': viewId});
  }

  @override
  Future<void> pause(int viewId) async {
    await methodChannel.invokeMethod('pause', {'viewId': viewId});
  }

  @override
  Future<void> seekTo(int viewId, int position) async {
    await methodChannel.invokeMethod('seekTo', {
      'viewId': viewId,
      'position': position,
    });
  }

  @override
  Future<void> setFullscreen(int viewId, bool fullscreen) async {
    await methodChannel.invokeMethod('setFullscreen', {
      'viewId': viewId,
      'fullscreen': fullscreen,
    });
  }

  @override
  Future<void> dispose(int viewId) async {
    await methodChannel.invokeMethod('dispose', {'viewId': viewId});
  }
} 