/// Copyright (c) 2025 Wojciech Plesiak

import '../logger/dlog.dart';

abstract class DLoggable {
  /// Logcat-like debug console logger.
  abstract DLog log;
}

/// Mix into a class to extend it with following methods.
mixin DLogMixin implements DLoggable {
  @override
  set log(DLog log) {}

  void logTrace(String msg) => log.trace(msg);
  void logVerbose(String msg) => log.verbose(msg);
  void logDebug(String msg) => log.debug(msg);
  void logInfo(String msg) => log.info(msg);
  void logNotice(String msg) => log.notice(msg);
  void logWarning(String msg, {dynamic error, StackTrace? stackTrace}) => log.warning(msg, error: error, stackTrace: stackTrace);
  void logAlert(String msg, {dynamic error, StackTrace? stackTrace}) => log.alert(msg, error: error, stackTrace: stackTrace);
  void logError(String msg, {dynamic error, StackTrace? stackTrace}) => log.error(msg, error: error, stackTrace: stackTrace);
  void logCustom(String msg, {dynamic error, StackTrace? stackTrace}) => log.custom(msg, error: error, stackTrace: stackTrace);
}
