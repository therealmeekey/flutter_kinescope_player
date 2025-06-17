import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_kinescope_player_method_channel.dart';

abstract class FlutterKinescopePlayerPlatform extends PlatformInterface {
  /// Constructs a FlutterKinescopePlayerPlatform.
  FlutterKinescopePlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterKinescopePlayerPlatform _instance = MethodChannelFlutterKinescopePlayer();

  /// The default instance of [FlutterKinescopePlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterKinescopePlayer].
  static FlutterKinescopePlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterKinescopePlayerPlatform] when
  /// they register themselves.
  static set instance(FlutterKinescopePlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initializePlayer(int viewId) {
    throw UnimplementedError('initializePlayer() has not been implemented.');
  }

  Future<void> loadVideo(int viewId, String videoId) {
    throw UnimplementedError('loadVideo() has not been implemented.');
  }

  Future<void> play(int viewId) {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> pause(int viewId) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<void> seekTo(int viewId, int position) {
    throw UnimplementedError('seekTo() has not been implemented.');
  }

  Future<void> setFullscreen(int viewId, bool fullscreen) {
    throw UnimplementedError('setFullscreen() has not been implemented.');
  }

  Future<void> dispose(int viewId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }
} 