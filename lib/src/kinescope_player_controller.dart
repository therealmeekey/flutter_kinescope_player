import 'package:flutter/foundation.dart';

import 'flutter_kinescope_player_platform_interface.dart';
import 'kinescope_video.dart';
import 'kinescope_player_config.dart';

/// Контроллер для управления плеером Kinescope
class KinescopePlayerController extends ChangeNotifier {
  final int _viewId;
  final FlutterKinescopePlayerPlatform _platform;
  
  KinescopeVideo? _currentVideo;
  bool _isPlaying = false;
  bool _isFullscreen = false;
  int _currentPosition = 0;
  int _duration = 0;
  bool _isLoading = false;
  String? _error;

  KinescopePlayerController({
    required int viewId,
    FlutterKinescopePlayerPlatform? platform,
  }) : _viewId = viewId,
       _platform = platform ?? FlutterKinescopePlayerPlatform.instance;

  /// Текущее видео
  KinescopeVideo? get currentVideo => _currentVideo;

  /// Играет ли видео
  bool get isPlaying => _isPlaying;

  /// Полноэкранный режим
  bool get isFullscreen => _isFullscreen;

  /// Текущая позиция в секундах
  int get currentPosition => _currentPosition;

  /// Длительность видео в секундах
  int get duration => _duration;

  /// Загружается ли видео
  bool get isLoading => _isLoading;

  /// Ошибка
  String? get error => _error;

  /// Инициализация плеера
  Future<void> initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _platform.initializePlayer(_viewId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Загрузка видео
  Future<void> loadVideo(String videoId, {KinescopePlayerConfig? config}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _platform.loadVideo(_viewId, videoId);
      
      // Если включен автоплей, запускаем видео
      if (config?.autoPlay == true) {
        await play();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Воспроизведение
  Future<void> play() async {
    try {
      await _platform.play(_viewId);
      _isPlaying = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Пауза
  Future<void> pause() async {
    try {
      await _platform.pause(_viewId);
      _isPlaying = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Перемотка к позиции
  Future<void> seekTo(int position) async {
    try {
      await _platform.seekTo(_viewId, position);
      _currentPosition = position;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Переключение полноэкранного режима
  Future<void> toggleFullscreen() async {
    try {
      final newFullscreenState = !_isFullscreen;
      await _platform.setFullscreen(_viewId, newFullscreenState);
      _isFullscreen = newFullscreenState;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Установка полноэкранного режима
  Future<void> setFullscreen(bool fullscreen) async {
    try {
      await _platform.setFullscreen(_viewId, fullscreen);
      _isFullscreen = fullscreen;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Обновление позиции (вызывается из нативного кода)
  void updatePosition(int position) {
    _currentPosition = position;
    notifyListeners();
  }

  /// Обновление длительности (вызывается из нативного кода)
  void updateDuration(int duration) {
    _duration = duration;
    notifyListeners();
  }

  /// Обновление состояния воспроизведения (вызывается из нативного кода)
  void updatePlayingState(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  /// Обновление видео (вызывается из нативного кода)
  void updateVideo(KinescopeVideo video) {
    _currentVideo = video;
    notifyListeners();
  }

  /// Очистка ресурсов
  Future<void> dispose() async {
    try {
      await _platform.dispose(_viewId);
    } catch (e) {
      // Игнорируем ошибки при очистке
    }
    super.dispose();
  }
} 