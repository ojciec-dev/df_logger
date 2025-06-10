/// Copyright (c) 2025 Wojciech Plesiak

import 'core.dart';

abstract class DLogConfig {
  static const defaultConfig = DefaultConfig();

  /// Lets you override the minimal log level for all loggers.
  static Level? minLogLevelOverride;

  /// Lets you specify which levels should be logger. Note: minLogLevel will still be respected.
  static Set<Level>? levelsAllowlistOverride;

  /// Optional buffer name for logs. If provided, logs will be stored in a buffer with this name.
  String? get bufferName => null;

  /// Number of logs to write to the file in a single batch.
  int get fileBatchSize;

  /// Whether logging is enabled. Useful when we want to keep logs in a class but enable them only for debugging.
  bool get enabled;

  /// Optional styles for log messages. Set to empty map to use default styles.
  Map<Level, Fasade>? get fasadeMap;

  LogFormat get logFormat;

  /// Minimal loggging level, log attempts below this level will be ignored.
  Level get minLoggingLevel;

  /// Max number of logs in the screen buffer. If the buffer is full, the oldest logs will be removed.
  int get screenBufferSize;

  /// [0.0 - 1.0] factor by which the screen buffer will additionally be trimmed when it exceeds its limit. As percentage of the [screenBufferSize].
  double get screenBufferTrimFactor;

  /// Whether to save logs to a file. If true, logs will be saved to a file at path provided via `DLogWritter.configureFileLogging()`. Path must be set before logging.
  bool get writeToFile;

  /// Whether to write logs to the screen buffer. If true, logs will be written to the screen.
  bool get writeToScreenBuffer;

  /// Optional logger method to be used instead of default [dart:developer.log(..)] method.
  Function(String coloredMessage, LogLine logLine)? get logger;
}

class DefaultConfig implements DLogConfig {
  @override
  final String? bufferName;

  @override
  final int fileBatchSize;

  @override
  final Map<Level, Fasade>? fasadeMap;

  @override
  final bool enabled;

  @override
  final LogFormat logFormat;

  @override
  final Level minLoggingLevel;

  @override
  final int screenBufferSize;

  @override
  final double screenBufferTrimFactor;

  @override
  final bool writeToFile;

  @override
  final bool writeToScreenBuffer;

  @override
  final Function(String coloredMessage, LogLine logLine)? logger;

  const DefaultConfig({
    this.bufferName,
    this.fasadeMap = DLogDefaults.defaultFasades,
    this.fileBatchSize = 1000,
    this.enabled = true,
    this.logFormat = DLogDefaults.logFormat,
    this.minLoggingLevel = Level.trace,
    this.screenBufferSize = 2000,
    this.screenBufferTrimFactor = 0.1,
    this.writeToFile = false,
    this.writeToScreenBuffer = true,
    this.logger,
  });

  DefaultConfig copyWith({
    String? bufferName,
    Map<Level, Fasade>? fasadeMap,
    bool? enabled,
    int? fileBatchSize,
    LogFormat? logFormat,
    Level? minLoggingLevel,
    int? screenBufferSize,
    double? screenBufferTrimFactor,
    bool? writeToFile,
    bool? writeToScreenBuffer,
    Function(String coloredMessage, LogLine logLine)? logger,
  }) {
    return DefaultConfig(
      bufferName: bufferName ?? this.bufferName,
      fasadeMap: fasadeMap ?? this.fasadeMap,
      fileBatchSize: fileBatchSize ?? this.fileBatchSize,
      enabled: enabled ?? this.enabled,
      logFormat: logFormat ?? this.logFormat,
      minLoggingLevel: minLoggingLevel ?? this.minLoggingLevel,
      screenBufferSize: screenBufferSize ?? this.screenBufferSize,
      screenBufferTrimFactor: screenBufferTrimFactor ?? this.screenBufferTrimFactor,
      writeToFile: writeToFile ?? this.writeToFile,
      writeToScreenBuffer: writeToScreenBuffer ?? this.writeToScreenBuffer,
      logger: logger ?? this.logger,
    );
  }
}
