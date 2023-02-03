/*
 * Created on Mon Nov 28 2022
 *
 * Copyright (c) 2022 Wojciech Plesiak
 *
 * [[ PACKAGE - DF_LOGGER ]]
 */

import '../logger/dlog.dart';

abstract class DLoggable {
  /// Logcat-like debug console logger.
  abstract DLog log;
}

/// Mix into a class to extend it with following methods.
mixin DLogMixin implements DLoggable {
  @override
  set log(DLog log) {}

  void logDebug(String msg) => log.debug(msg);
  void logInfo(String msg) => log.info(msg);
  void logWarning(String msg, [Exception? ex]) => log.warning(msg, ex);
  void logError(String msg, [Exception? ex]) => log.error(msg, ex);
}
