import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kinescope_player/flutter_kinescope_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinescope Player Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KinescopePlayerExample(),
    );
  }
}

class KinescopePlayerExample extends StatefulWidget {
  const KinescopePlayerExample({super.key});

  @override
  State<KinescopePlayerExample> createState() => _KinescopePlayerExampleState();
}

class _KinescopePlayerExampleState extends State<KinescopePlayerExample> {
  late KinescopePlayerController _controller;
  bool _isFullscreen = false;

  // final String videoId = '6785usqYquEgsj3bVoEh5H';
  final String videoId = 'sEsxJQ7Hi4QLWwbmZEFfgz';

  @override
  void initState() {
    super.initState();
    _controller = KinescopePlayerController(viewId: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Kinescope Player Example'),
        actions: [
          IconButton(
            onPressed: _toggleFullscreen,
            icon:
                Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
          ),
        ],
      ),
      body: Column(
        children: [
          // Плеер
          AspectRatio(
            aspectRatio: 16 / 9,
            child: KinescopePlayerWidget(
              videoId: videoId,
              controller: _controller,
              config: const KinescopePlayerConfig(
                autoPlay: true,
                showControls: true,
                enableFullscreen: true,
                buttonColor: Colors.white,
                progressBarColor: Colors.red,
                scrubberColor: Colors.red,
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
              ),
              placeholder: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Ошибка загрузки видео',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Контролы
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Информация о видео
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_controller.currentVideo != null) ...[
                          Text(
                            'Видео: ${_controller.currentVideo!.title}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          if (_controller.currentVideo!.isLive)
                            const Chip(
                              label: Text('LIVE'),
                              backgroundColor: Colors.red,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          'Позиция: ${_formatDuration(_controller.currentPosition)} / ${_formatDuration(_controller.duration)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        if (_controller.error != null)
                          Text(
                            'Ошибка: ${_controller.error}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.red,
                                    ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Кнопки управления
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: _controller.isPlaying
                            ? _controller.pause
                            : _controller.play,
                        icon: Icon(_controller.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        label: Text(
                            _controller.isPlaying ? 'Пауза' : 'Воспроизвести'),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () => _controller.seekTo(0),
                        icon: const Icon(Icons.replay),
                        label: const Text('Перемотать'),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: _toggleFullscreen,
                        icon: Icon(_isFullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen),
                        label: Text(_isFullscreen ? 'Выйти' : 'Полный экран'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Слайдер прогресса
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    if (_controller.duration == 0)
                      return const SizedBox.shrink();

                    return Column(
                      children: [
                        Slider(
                          value: _controller.currentPosition.toDouble(),
                          min: 0,
                          max: _controller.duration.toDouble(),
                          onChanged: (value) {
                            _controller.seekTo(value.toInt());
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(_controller.currentPosition)),
                            Text(_formatDuration(_controller.duration)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      // Переходим в полноэкранный режим
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => KinescopeFullscreenPlayer(
            videoId: videoId,
            config: const KinescopePlayerConfig(
              autoPlay: true,
              showControls: true,
              enableFullscreen: true,
            ),
            onExitFullscreen: () {
              setState(() {
                _isFullscreen = false;
              });
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
          ),
        ),
      );
    } else {
      // Выходим из полноэкранного режима
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
}
