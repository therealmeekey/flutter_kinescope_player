library flutter_kinescope_player;

export 'src/flutter_kinescope_player_platform_interface.dart';
export 'src/kinescope_player_widget.dart';
export 'src/kinescope_player_controller.dart';
export 'src/kinescope_video.dart';
export 'src/kinescope_player_config.dart';

import 'package:flutter/services.dart';

class KinescopePlayerEvents {
  static const MethodChannel _eventChannel = MethodChannel('flutter_kinescope_player_events');

  static void listenOnTapFullscreen(void Function(bool isFullscreen) onTapFullscreen) {
    _eventChannel.setMethodCallHandler((call) async {
      if (call.method == 'onTapFullscreen') {
        final bool isFullscreen = call.arguments['isFullscreen'] == true;
        onTapFullscreen(isFullscreen);
      }
    });
  }
}
