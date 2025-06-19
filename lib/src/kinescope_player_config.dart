/// Конфигурация для плеера Kinescope
class KinescopePlayerConfig {
  /// Автоматическое воспроизведение
  final bool autoPlay;

  /// Показывать ли кнопку полноэкранного режима
  final bool showFullscreenButton;

  /// Показывать ли кнопку настроек
  final bool showOptionsButton;

  /// Показывать ли кнопку субтитров
  final bool showSubtitlesButton;

  /// Показывать ли полосу прогресса
  final bool showSeekBar;

  /// Показывать ли длительность
  final bool showDuration;

  /// Показывать ли вложения
  final bool showAttachments;

  /// Referer для запросов
  final String referer;

  /// Дополнительные заголовки для DRM запросов
  final Map<String, String>? drmHeaders;

  const KinescopePlayerConfig({
    this.autoPlay = false,
    this.showFullscreenButton = true,
    this.showOptionsButton = true,
    this.showSubtitlesButton = false,
    this.showSeekBar = true,
    this.showDuration = true,
    this.showAttachments = false,
    this.referer = 'https://kinescope.io/',
    this.drmHeaders,
  });

  Map<String, dynamic> toMap() {
    return {
      'autoPlay': autoPlay,
      'showFullscreenButton': showFullscreenButton,
      'showOptionsButton': showOptionsButton,
      'showSubtitlesButton': showSubtitlesButton,
      'showSeekBar': showSeekBar,
      'showDuration': showDuration,
      'showAttachments': showAttachments,
      'referer': referer,
      'drmHeaders': drmHeaders,
    };
  }

  factory KinescopePlayerConfig.fromMap(Map<String, dynamic> map) {
    return KinescopePlayerConfig(
      autoPlay: map['autoPlay'] ?? false,
      showFullscreenButton: map['showFullscreenButton'] ?? true,
      showOptionsButton: map['showOptionsButton'] ?? true,
      showSubtitlesButton: map['showSubtitlesButton'] ?? false,
      showSeekBar: map['showSeekBar'] ?? true,
      showDuration: map['showDuration'] ?? true,
      showAttachments: map['showAttachments'] ?? false,
      referer: map['referer'] ?? 'https://kinescope.io/',
      drmHeaders: map['drmHeaders'] != null
          ? Map<String, String>.from(map['drmHeaders'])
          : null,
    );
  }

  KinescopePlayerConfig copyWith({
    bool? autoPlay,
    bool? showFullscreenButton,
    bool? showOptionsButton,
    bool? showSubtitlesButton,
    bool? showSeekBar,
    bool? showDuration,
    bool? showAttachments,
    String? referer,
    Map<String, String>? drmHeaders,
  }) {
    return KinescopePlayerConfig(
      autoPlay: autoPlay ?? this.autoPlay,
      showFullscreenButton: showFullscreenButton ?? this.showFullscreenButton,
      showOptionsButton: showOptionsButton ?? this.showOptionsButton,
      showSubtitlesButton: showSubtitlesButton ?? this.showSubtitlesButton,
      showSeekBar: showSeekBar ?? this.showSeekBar,
      showDuration: showDuration ?? this.showDuration,
      showAttachments: showAttachments ?? this.showAttachments,
      referer: referer ?? this.referer,
      drmHeaders: drmHeaders ?? this.drmHeaders,
    );
  }
}
