/*
 * Created on Tue Oct 11 2022
 *
 * Copyright (c) 2022 Wojciech Plesiak
 *
 * [[ PACKAGE - DF_LOGGER ]]
 *
 * dart.developer logger wrapper that format log messages similar to Android's logcat.
 */

import 'dart:developer' as developer;

import '../colors/asci_colors.dart';

/// Logcat-like logging wrapper that outputs colored logs in the debug console without 3rd packages.
/// ANSI escape codes are used to color the output.
///
/// Provides DEBUG, INFO, WARNING and ERROR log level messages with date, time, log level and tags, eg
/// ```
/// [log] 2022-11-14 22:48:39:893 D/FileTag: This is a debug message
/// ```
///
/// HOW TO
///
/// 1. Create level logger instance either manually
/// ```dart
/// final _log = DLog('FileTag');
/// ```
/// or using DLogMixin
/// ```dart
/// class MyClass with DLogMixin {
///   @override
///   DLog log = DLog('MyClass');
/// }
/// ```
/// Override enabled, minLoggingLevel or logging method if needed
/// ```dart
/// final _log = DLog('FileTag').apply(
///   enabled: false,
///   minLoggingLevel: Level.warning,
///   logger: (msg) {},
/// );
/// ```
///
/// 2. Use via field
/// ```dart
///   _log.verbose('This is a verbose message');
///   _log.debug('This is a debug message');
///   _log.info('This is an info message');
///   _log.warning('This is a warning message with optional exception');
///   _log.error('This is an error message with optional exception');
/// ```
/// or via methods if mixin was used
/// ```dart
///   logVerbose('This is a verbose message');
///   logDebug('This is a debug message');
///   logInfo('This is an info message');
///   logWarning('This is a warning message with optional exception');
///   logError('This is an error message with optional exception');
/// ```
///
/// 3. Profit
///```
/// [log] 2022-11-14 22:48:39:893 V/FileTag: This is a verbose message
/// [log] 2022-11-14 22:48:39:893 D/FileTag: This is a debug message
/// [log] 2022-11-14 22:48:39:894 I/FileTag: This is an info message
/// [log] 2022-11-14 22:48:39:895 W/FileTag: This is a warning message with optional exception
/// [log] 2022-11-14 22:48:39:896 E/FileTag: This is an error message with optional exception
/// ```
class DLog {
  /// Optional tag, usually name of the class.
  final String? tag;

  /// Optional additional tag, useful for grouping logs from the same feature.
  final String? group;

  /// Minimal loggging level, log attempts below this level will be ignored.
  Level minLoggingLevel;

  /// Optional logger method to be used instead of default [dart:developer.log(..)] method.
  Function(String)? logger;

  /// Whether logging is enabled. Useful when we want to keep logs in a class but enable them only for debugging.
  bool enabled = true;

  final String _msgPrefix;

  DLog(this.tag, {this.group, Level? minLogLevel, this.logger})
      : _msgPrefix = generatePrefix(tag, group),
        minLoggingLevel = minLogLevel ?? Level.verbose;

  /// VERBOSE

  static void v(String tag, String msg, {String? group}) => DLog(tag, group: group).verbose(msg);
  void verbose(String msg) => _log(Level.verbose, msg);

  /// DEBUG

  static void d(String tag, String msg, {String? group}) => DLog(tag, group: group).debug(msg);
  void debug(String msg) => _log(Level.debug, msg);

  /// INFO

  static void i(String tag, String msg, {String? group}) => DLog(tag, group: group).info(msg);
  void info(String msg) => _log(Level.info, msg);

  /// WARNING

  static void w(String tag, String msg, {String? group, Exception? ex}) => DLog(tag, group: group).warning(msg, ex);
  void warning(String msg, [Exception? ex]) {
    _log(Level.warning, msg);
    if (ex != null) {
      _log(Level.warning, ex.toString());
    }
  }

  /// ERROR

  static void e(String tag, String msg, {String? group, Exception? ex}) => DLog(tag, group: group).error(msg, ex);
  void error(String msg, [Exception? ex]) {
    _log(Level.error, msg);
    if (ex != null) {
      _log(Level.error, ex.toString());
    }
  }

  // #region internal

  void _log(Level level, String msg) {
    /// do not print below importance level
    if (!enabled || level.importance < minLoggingLevel.importance) return;

    String prefix = _msgPrefix;
    if (prefix.isNotEmpty) {
      prefix += ': ';
    }
    final now = DateTime.now().toString().split(' ');
    final date = now[0];
    final time = now[1];

    _print(
      level: level,
      msg: msg,
      date: date,
      time: time,
      prefix: prefix,
    );
  }

  /// This is what prints the log message. Currently it uses [dart:developer] log method.
  void _print({
    required Level level,
    required String msg,
    required String date,
    required String time,
    required String prefix,
  }) {
    final message = level.color.colorize('$date $time ${level.letter}/$prefix$msg');
    if (logger != null) {
      logger?.call(message);
    } else {
      developer.log(message, time: DateTime.now());
    }
  }

  // #endregion

  /// Change configuration after DLog instance has been created.
  DLog apply({bool? enabled, Level? minLoggingLevel, Function(String)? logger}) {
    if (enabled != null) this.enabled = enabled;
    if (minLoggingLevel != null) this.minLoggingLevel = minLoggingLevel;
    if (logger != null) this.logger = logger;

    return this;
  }

  /// Generates log message prefix.
  ///
  /// Returns one of:
  /// * `TAG<GROUP>`  - when both [tag] and [group] are not null
  /// * `TAG`         - when [tag] is not null but [group] is null
  /// * `<GROUP>`     - when [tag] is null but [group] is not
  /// * empty string  - when both [tag] and [group] are null
  static String generatePrefix(String? tag, String? group) {
    String postfix = '';
    if (group != null) {
      postfix = '<$group>';
    }

    String tagString = postfix;
    if (tag != null) {
      tagString = '$tag$tagString';
    }

    return tagString;
  }
}

/// Log levels
enum Level {
  verbose,
  debug,
  info,
  warning,
  error,
}

/// Dart enums are very basic and do not allow holding data.
/// Adding an extension function like this is a well working workaround.
extension _LevelExt on Level {
  String get letter {
    switch (this) {
      case Level.debug:
        return 'D';
      case Level.info:
        return 'I';
      case Level.warning:
        return 'W';
      case Level.error:
        return 'E';
      case Level.verbose:
      default:
        return 'V';
    }
  }

  AsciColor get color {
    switch (this) {
      case Level.debug:
        return AsciColor.green;
      case Level.info:
        return AsciColor.blue;
      case Level.warning:
        return AsciColor.yellow;
      case Level.error:
        return AsciColor.red;
      case Level.verbose:
      default:
        return AsciColor.white;
    }
  }

  /// higher number = higher importance
  int get importance {
    switch (this) {
      case Level.debug:
        return 1;
      case Level.info:
        return 2;
      case Level.warning:
        return 3;
      case Level.error:
        return 4;
      case Level.verbose:
      default:
        return 0;
    }
  }
}
