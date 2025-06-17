<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Kinescope Player

Flutter плагин для интеграции с [Kinescope SDK](https://github.com/kinescope/kotlin-kinescope-player) для воспроизведения видео в Flutter приложениях.

## Возможности

- ✅ Воспроизведение видео из Kinescope
- ✅ Автозапуск видео
- ✅ Полноэкранный режим
- ✅ Настраиваемые цвета и стили
- ✅ Поддержка Live трансляций
- ✅ Управление воспроизведением (play/pause/seek)
- ✅ Отображение постеров
- ✅ Аналитика событий

## Установка

Добавьте зависимость в ваш `pubspec.yaml`:

```yaml
dependencies:
  flutter_kinescope_player: ^0.0.1
```

## Использование

### Базовое использование

```dart
import 'package:flutter_kinescope_player/flutter_kinescope_player.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KinescopePlayerWidget(
      videoId: 'sEsxJQ7Hi4QLWwbmZEFfgz',
      config: const KinescopePlayerConfig(
        autoPlay: true, // Автозапуск видео
        showControls: true,
        enableFullscreen: true,
      ),
    );
  }
}
```

### С контроллером

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late KinescopePlayerController _controller;

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
    return Column(
      children: [
        KinescopePlayerWidget(
          videoId: 'sEsxJQ7Hi4QLWwbmZEFfgz',
          controller: _controller,
          config: const KinescopePlayerConfig(
            autoPlay: true,
            showControls: true,
            enableFullscreen: true,
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _controller.isPlaying ? _controller.pause : _controller.play,
              child: Text(_controller.isPlaying ? 'Пауза' : 'Воспроизвести'),
            ),
            ElevatedButton(
              onPressed: () => _controller.seekTo(0),
              child: Text('Перемотать'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Полноэкранный режим

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => KinescopeFullscreenPlayer(
      videoId: 'sEsxJQ7Hi4QLWwbmZEFfgz',
      config: const KinescopePlayerConfig(
        autoPlay: true,
        showControls: true,
        enableFullscreen: true,
      ),
      onExitFullscreen: () {
        Navigator.of(context).pop();
      },
    ),
  ),
);
```

### Настройка цветов

```dart
KinescopePlayerWidget(
  videoId: 'sEsxJQ7Hi4QLWwbmZEFfgz',
  config: const KinescopePlayerConfig(
    autoPlay: true,
    buttonColor: Colors.white,
    progressBarColor: Colors.red,
    scrubberColor: Colors.red,
    playedColor: Colors.red,
    bufferedColor: Colors.grey,
  ),
)
```

## Конфигурация

### KinescopePlayerConfig

| Параметр | Тип | По умолчанию | Описание |
|----------|-----|--------------|----------|
| `autoPlay` | `bool` | `false` | Автозапуск видео |
| `showControls` | `bool` | `true` | Показывать элементы управления |
| `enableFullscreen` | `bool` | `true` | Включить полноэкранный режим |
| `buttonColor` | `Color?` | `null` | Цвет кнопок |
| `progressBarColor` | `Color?` | `null` | Цвет прогресс-бара |
| `scrubberColor` | `Color?` | `null` | Цвет ползунка |
| `playedColor` | `Color?` | `null` | Цвет воспроизведенной части |
| `bufferedColor` | `Color?` | `null` | Цвет загруженной части |

## Контроллер

### Методы

- `play()` - Воспроизвести
- `pause()` - Пауза
- `seekTo(int position)` - Перемотать к позиции (в секундах)
- `setFullscreen(bool fullscreen)` - Установить полноэкранный режим
- `toggleFullscreen()` - Переключить полноэкранный режим
- `dispose()` - Очистить ресурсы

### Свойства

- `isPlaying` - Играет ли видео
- `isFullscreen` - Полноэкранный режим
- `currentPosition` - Текущая позиция (в секундах)
- `duration` - Длительность видео (в секундах)
- `isLoading` - Загружается ли видео
- `error` - Ошибка
- `currentVideo` - Информация о текущем видео

## Пример

Запустите пример приложения:

```bash
cd example
flutter run
```

Пример демонстрирует:
- Автозапуск видео с ID `sEsxJQ7Hi4QLWwbmZEFfgz`
- Управление воспроизведением
- Полноэкранный режим
- Настройку цветов
- Отображение прогресса

## Структура проекта

```
flutter_kinescope_player/
├── lib/
│   ├── src/
│   │   ├── flutter_kinescope_player_platform_interface.dart
│   │   ├── flutter_kinescope_player_method_channel.dart
│   │   ├── kinescope_player_widget.dart
│   │   ├── kinescope_player_controller.dart
│   │   ├── kinescope_video.dart
│   │   └── kinescope_player_config.dart
│   └── flutter_kinescope_player.dart
├── android/
│   └── src/main/kotlin/com/example/flutter_kinescope_player/
│       ├── FlutterKinescopePlayerPlugin.kt
│       ├── KinescopePlayerViewFactory.kt
│       └── GeneratedPluginRegistrant.kt
├── example/
│   ├── lib/main.dart
│   └── android/
└── README.md
```

## Требования

- Flutter >= 1.17.0
- Android API Level >= 21
- Kotlin >= 1.9.0

## Зависимости

- [kotlin-kinescope-player](https://github.com/kinescope/kotlin-kinescope-player) - Нативный Android SDK
- plugin_platform_interface - Для создания платформенного интерфейса

## Лицензия

MIT License
