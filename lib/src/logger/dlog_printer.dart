/// Copyright (c) 2025 Wojciech Plesiak

import 'dart:developer' as developer;

import '../colors/asci_colors.dart';
import '../colors/dlog_color.dart';
import '../core/dlog_config.dart';
import '../core/fasade.dart';
import '../core/level.dart';
import '../core/log_line.dart';
import 'dlog_writer.dart';

/// Writes logs to a file.
class DLogPrinter {
  /// Configuration for the logger.
  final DLogConfig config;

  /// Tag for log messages.
  final String? tag;

  /// Group for log messages.
  final String? group;

  /// Writes logs to a file.
  final DLogWritter _writter;

  DLogPrinter(this.config, this.tag, this.group) : _writter = DLogWritter(config);

  /// Prints the log message to debug console and optionally writes it to screen and/or file buffer.
  void print(LogLine log) {
    /// do not print below importance level
    if (!config.enabled || log.level.importance < (DLogConfig.minLogLevelOverride?.importance ?? config.minLoggingLevel.importance)) return;

    if (DLogConfig.levelsAllowlistOverride?.isNotEmpty == true) {
      /// do not print if level is not on the allowlist override
      if (!DLogConfig.levelsAllowlistOverride!.contains(log.level)) return;
    }

    final coloredMessage = _colorize(
      log.formattedMessage,
      level: log.level,
      fasade: log.fasade,
    );

    _writter.write(log);
    if (config.logger != null) {
      config.logger?.call(coloredMessage, log);
    } else {
      developer.log(coloredMessage, error: log.error, stackTrace: log.stackTrace);
    }
  }

  String _colorize(String msg, {required Level level, Fasade? fasade}) {
    final style = fasade?.hasColor == true ? fasade : config.fasadeMap?[level];
    if (style?.fgColor == null && style?.bgColor == null) {
      return level.color.colorize(msg);
    }

    if (fasade?.swapped == true) {
      // swap fg and bg colors and make text black if no fg color
      return AsciColor.rgb.rgbColorize(msg, style?.bgColor ?? const DLogColor(0xFF000000), style?.fgColor);
    }

    return AsciColor.rgb.rgbColorize(msg, style?.fgColor, style?.bgColor);
  }
}
