import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kinescope_player_controller.dart';
import 'kinescope_player_config.dart';

/// Flutter виджет для отображения плеера Kinescope
class KinescopePlayerWidget extends StatefulWidget {
  final String videoId;
  final KinescopePlayerConfig? config;
  final KinescopePlayerController? controller;
  final double aspectRatio;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const KinescopePlayerWidget({
    super.key,
    required this.videoId,
    this.aspectRatio = 16 / 9,
    this.config,
    this.controller,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.errorWidget,
  });

  @override
  State<KinescopePlayerWidget> createState() => _KinescopePlayerWidgetState();
}

class _KinescopePlayerWidgetState extends State<KinescopePlayerWidget> {
  late KinescopePlayerController _controller;
  int? _viewId;
  String? _lastError;
  bool _isViewCreated = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? KinescopePlayerController(viewId: 0);
    // Не инициализируем плеер здесь, дождемся создания AndroidView
  }

  Future<void> _initializePlayer() async {
    try {
      await _controller.initialize();
      await _loadVideo();
    } catch (e) {
      setState(() {
        _lastError = 'Ошибка инициализации: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.error != null || _lastError != null) {
            return _buildErrorWidget();
          }
          return _buildPlayerWidget();
        },
      ),
    );
  }

  Widget _buildPlayerWidget() {
    debugPrint(
        'KinescopePlayer: Building player widget, viewId: $_viewId, isViewCreated: $_isViewCreated');
    return AndroidView(
      viewType: 'flutter_kinescope_player_view',
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: {
        'viewId': _viewId ?? 0,
        'config': widget.config?.toMap(),
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Widget _buildErrorWidget() {
    final errorMessage =
        _controller.error ?? _lastError ?? 'Неизвестная ошибка';

    return widget.errorWidget ??
        Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ошибка загрузки видео',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _lastError = null;
                      });
                      _initializePlayer();
                    },
                    child: const Text('Повторить'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Video ID: ${widget.videoId}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  void _onPlatformViewCreated(int id) {
    _viewId = id;
    _isViewCreated = true;

    // Обновляем контроллер с правильным viewId
    _controller = KinescopePlayerController(viewId: id);

    // Теперь инициализируем плеер и загружаем видео
    _initializePlayer();
  }

  Future<void> _loadVideo() async {
    try {
      await _controller.loadVideo(
        widget.videoId,
        config: widget.config,
      );

      // await _controller.play();
    } catch (e) {
      setState(() {
        _lastError = 'Ошибка загрузки видео: $e';
      });
    }
  }
}

/// Виджет для полноэкранного режима
class KinescopeFullscreenPlayer extends StatefulWidget {
  final String videoId;
  final KinescopePlayerConfig? config;
  final VoidCallback? onExitFullscreen;

  const KinescopeFullscreenPlayer({
    super.key,
    required this.videoId,
    this.config,
    this.onExitFullscreen,
  });

  @override
  State<KinescopeFullscreenPlayer> createState() =>
      _KinescopeFullscreenPlayerState();
}

class _KinescopeFullscreenPlayerState extends State<KinescopeFullscreenPlayer> {
  late KinescopePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KinescopePlayerController(viewId: 0);
    _initializeFullscreenPlayer();
  }

  Future<void> _initializeFullscreenPlayer() async {
    try {
      await _controller.initialize();
      await _controller.loadVideo(
        widget.videoId,
        config: widget.config?.copyWith(autoPlay: true),
      );
      await _controller.setFullscreen(true);
    } catch (e) {
      debugPrint('KinescopeFullscreenPlayer: Error initializing: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: KinescopePlayerWidget(
                videoId: widget.videoId,
                config: widget.config?.copyWith(autoPlay: true),
                controller: _controller,
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () {
                  _controller.setFullscreen(false);
                  widget.onExitFullscreen?.call();
                },
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
