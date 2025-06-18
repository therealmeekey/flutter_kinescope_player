import 'package:flutter/material.dart';
import 'package:flutter_kinescope_player/flutter_kinescope_player.dart';

const drmVideoId = 'rVNR6f1SGPmT3MgDYriWJ4';
const drmDomainUrl = 'https://umschool.net';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const DrmKinescopePlayerPage(),
    );
  }
}

class DrmKinescopePlayerPage extends StatefulWidget {
  const DrmKinescopePlayerPage({super.key});

  @override
  State<DrmKinescopePlayerPage> createState() => _DrmKinescopePlayerPageState();
}

class _DrmKinescopePlayerPageState extends State<DrmKinescopePlayerPage>
    with WidgetsBindingObserver {
  late KinescopePlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = KinescopePlayerController(viewId: 0);

    // Инициализируем плеер и загружаем видео
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _controller.initialize();
    await _controller.loadVideo(drmVideoId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Kinescope DRM Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KinescopePlayerWidget(
              videoId: drmVideoId,
              controller: _controller,
              config: KinescopePlayerConfig(
                referer: drmDomainUrl,
                autoPlay: true,
                showFullscreenButton: true,
                showOptionsButton: true,
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
            TextButton(
              onPressed: () async {
                try {
                  await _controller.play();
                } catch (e) {
                  print('Error in play: $e');
                }
              },
              child: const Text("PLAY"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _controller.pause();
                } catch (e) {
                  print('Error in pause: $e');
                }
              },
              child: const Text("PAUSE"),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  children: [
                    Text('Is Playing: ${_controller.isPlaying}'),
                    if (_controller.error != null)
                      Text('Error: ${_controller.error}',
                          style: const TextStyle(color: Colors.red)),
                    Text(
                        'Position: ${_controller.currentPosition}s / ${_controller.duration}s'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
