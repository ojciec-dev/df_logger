## 1.1.0

* New parameter to enable/disable logger instance.
* Additional logging level: 'verbose'
* Allowing to change min logging level and logger method after DLog instance has
  been created.

## 1.0.0

* Logcat-like logger for Flutter. Utilizes dart:developer `log` method to print
  messages in the debug console. Allows to print messages at four importance levels
  (debug, info, warning and error). Each level has its own color. Allows to
  provide a tag an optional secondary tag for ease of log identification. Prints
  not only log message but also date and time.
