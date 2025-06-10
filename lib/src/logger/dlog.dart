/// Copyright (c) 2025 Wojciech Plesiak
/*
 * dart.developer logger wrapper that format log messages similarly to Android's logcat.
 */

import '../core/core.dart';
import 'dlog_printer.dart';

/// Logcat-like logging wrapper that outputs colored logs in the debug console without 3rd packages.
/// ANSI escape codes are used to color the output.
///
/// Provides TRACE, DEBUG, INFO, NOTICE, WARNING, ALERT and ERROR log level messages with date, time, log level and tags, eg
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
/// final _log = DLog(
///   'FileTag'
//    config: DLogConfig.defaultConfig.copyWith(
//      logger: (coloredMessage, logLine) {}
//      minLoggingLevel: level,
//    ),
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

  /// Configuration for the logger.
  final DLogConfig config;

  final DLogPrinter _printer;

  DLog(
    this.tag, {
    this.group,
    this.config = DLogConfig.defaultConfig,
  }) : _printer = DLogPrinter(config, tag, group);

  /// TRACE

  static void t(String tag, String msg, {String? group, Fasade? fasade}) => DLog(tag, group: group).trace(msg, fasade: fasade);
  void trace(String msg, {Fasade? fasade}) => _log(Level.trace, msg, tag, fasade);

  /// VERBOSE

  static void v(String tag, String msg, {String? group, Fasade? fasade}) => DLog(tag, group: group).verbose(msg, fasade: fasade);
  void verbose(String msg, {Fasade? fasade}) => _log(Level.verbose, msg, tag, fasade);

  /// DEBUG

  static void d(String tag, String msg, {String? group, Fasade? fasade}) => DLog(tag, group: group).debug(msg, fasade: fasade);
  void debug(String msg, {Fasade? fasade}) => _log(Level.debug, msg, tag, fasade);

  /// INFO

  static void i(String tag, String msg, {String? group, Fasade? fasade}) => DLog(tag, group: group).info(msg, fasade: fasade);
  void info(String msg, {Fasade? fasade}) => _log(Level.info, msg, tag, fasade);

  /// NOTICE

  static void n(String tag, String msg, {String? group, Fasade? fasade}) => DLog(tag, group: group).notice(msg, fasade: fasade);
  void notice(String msg, {Fasade? fasade}) => _log(Level.notice, msg, tag, fasade);

  /// WARNING

  static void w(String tag, String msg, {dynamic error, Fasade? fasade, String? group, StackTrace? stackTrace}) =>
      DLog(tag, group: group).warning(msg, fasade: fasade, error: error, stackTrace: stackTrace);
  void warning(String msg, {Fasade? fasade, dynamic error, StackTrace? stackTrace}) {
    _log(Level.warning, msg, tag, fasade, error, stackTrace);
  }

  /// ALERT

  static void a(String tag, String msg, {dynamic error, Fasade? fasade, String? group, StackTrace? stackTrace}) =>
      DLog(tag, group: group).alert(msg, fasade: fasade, error: error, stackTrace: stackTrace);
  void alert(String msg, {dynamic error, Fasade? fasade, StackTrace? stackTrace}) {
    _log(Level.alert, msg, tag, fasade, error, stackTrace);
  }

  /// ERROR

  static void e(String tag, String msg, {dynamic error, Fasade? fasade, String? group, StackTrace? stackTrace}) =>
      DLog(tag, group: group).error(msg, fasade: fasade, error: error, stackTrace: stackTrace);
  void error(String msg, {dynamic error, Fasade? fasade, StackTrace? stackTrace}) {
    _log(Level.error, msg, tag, fasade, error, stackTrace);
  }

  /// CUSTOM

  static void c(String tag, String msg, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      DLog(tag, group: group).custom(msg, fasade: fasade, error: error, stackTrace: stackTrace);
  void custom(String msg, {Fasade? fasade, dynamic error, StackTrace? stackTrace}) {
    _log(Level.custom, msg, tag, fasade, error, stackTrace);
  }

  void _log(
    Level level,
    String msg, [
    String? tag,
    Fasade? fasade,
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      _printer.print(LogLine(
        level,
        msg,
        tag: tag,
        fasade: fasade,
        error: error,
        stackTrace: stackTrace,
        logFormat: config.logFormat,
      ));

  static void printSampleLogs() {
    DLog.t('DLog', 'This is a trace message');
    DLog.v('DLog', 'This is a verbose message');
    DLog.d('DLog', 'This is a debug message');
    DLog.i('DLog', 'This is an info message');
    DLog.n('DLog', 'This is a notice message');
    DLog.w('DLog', 'This is a warning message');
    DLog.a('DLog', 'This is an alert message');
    DLog.e('DLog', 'This is an error message');
    DLog.c('DLog', 'This is a custom message');

    DLog.t('DLog', 'This is a trace message with swapped fasade', fasade: Fasade.swapped());
    DLog.v('DLog', 'This is a verbose message with swapped fasade', fasade: Fasade.swapped());
    DLog.d('DLog', 'This is a debug message with swapped fasade', fasade: Fasade.swapped());
    DLog.i('DLog', 'This is an info message with swapped fasade', fasade: Fasade.swapped());
    DLog.n('DLog', 'This is a notice message with swapped fasade', fasade: Fasade.swapped());
    DLog.w('DLog', 'This is a warning message with swapped fasade', fasade: Fasade.swapped());
    DLog.a('DLog', 'This is an alert message with swapped fasade', fasade: Fasade.swapped());
    DLog.e('DLog', 'This is an error message with swapped fasade', fasade: Fasade.swapped());
    DLog.c('DLog', 'This is a custom message with swapped fasade', fasade: Fasade.swapped());
  }
}
