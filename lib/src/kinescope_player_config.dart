import 'package:flutter/material.dart';

/// Конфигурация для плеера Kinescope
class KinescopePlayerConfig {
  final bool autoPlay;
  final bool showControls;
  final bool enableFullscreen;
  final Color? buttonColor;
  final Color? progressBarColor;
  final Color? scrubberColor;
  final Color? playedColor;
  final Color? bufferedColor;
  final String? customButtonIcon;
  final VoidCallback? onCustomButtonTap;
  final Function(String, Map<String, dynamic>)? onAnalytics;

  const KinescopePlayerConfig({
    this.autoPlay = false,
    this.showControls = true,
    this.enableFullscreen = true,
    this.buttonColor,
    this.progressBarColor,
    this.scrubberColor,
    this.playedColor,
    this.bufferedColor,
    this.customButtonIcon,
    this.onCustomButtonTap,
    this.onAnalytics,
  });

  Map<String, dynamic> toMap() {
    return {
      'autoPlay': autoPlay,
      'showControls': showControls,
      'enableFullscreen': enableFullscreen,
      'buttonColor': buttonColor?.value,
      'progressBarColor': progressBarColor?.value,
      'scrubberColor': scrubberColor?.value,
      'playedColor': playedColor?.value,
      'bufferedColor': bufferedColor?.value,
      'customButtonIcon': customButtonIcon,
    };
  }

  KinescopePlayerConfig copyWith({
    bool? autoPlay,
    bool? showControls,
    bool? enableFullscreen,
    Color? buttonColor,
    Color? progressBarColor,
    Color? scrubberColor,
    Color? playedColor,
    Color? bufferedColor,
    String? customButtonIcon,
    VoidCallback? onCustomButtonTap,
    Function(String, Map<String, dynamic>)? onAnalytics,
  }) {
    return KinescopePlayerConfig(
      autoPlay: autoPlay ?? this.autoPlay,
      showControls: showControls ?? this.showControls,
      enableFullscreen: enableFullscreen ?? this.enableFullscreen,
      buttonColor: buttonColor ?? this.buttonColor,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      scrubberColor: scrubberColor ?? this.scrubberColor,
      playedColor: playedColor ?? this.playedColor,
      bufferedColor: bufferedColor ?? this.bufferedColor,
      customButtonIcon: customButtonIcon ?? this.customButtonIcon,
      onCustomButtonTap: onCustomButtonTap ?? this.onCustomButtonTap,
      onAnalytics: onAnalytics ?? this.onAnalytics,
    );
  }
} 