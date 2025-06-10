# /// Copyright (c) 2022 Wojciech Plesiak

## 2.0.2

* Introduced OnScreenDlog widget.

## 2.0.1

* Fix DLog.c mapping to proper log level.
* Adjust log debug, error and custom log colors.
* Ability to disable logging to file after it was enabled. 

## 2.0.0

* BREAKING CHANGES: Removed: `minLoggingLevel`, `logger` and `enabled` DLog arguments. Introduced `config` argument instead. 
* BREAKING CHANGES: Changes signatures of `warning` and `error` logging methods.
* Introduced `DLogConfig` to allow for log format and colors customizations.
* Support for RGB log colors (foreground and background).
* Introduced buffers.

## 1.1.2

* Removing dependency on intl package

## 1.1.1

* Changed 1 constraint in pubspec.yaml: intl: ^0.17.0 -> ^0.18.0 

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
