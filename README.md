## Summary

Logcat-like logging wrapper that outputs colored logs in the debug console
without 3rd packages. Uses ANSI escape codes for output coloring.

## Features

Provides VERBOSE, DEBUG, INFO, WARNING and ERROR log level messages with date, time, log level and tags, eg
```
[log] 2022-11-14 22:48:39:893 D/FileTag: This is a debug message
```

## Getting started

```dart
dependencies:
  df_logger:
    git:
      url: https://github.com/ojciec-dev/df_logger.git
```

## Usage

Create [DLog] instance

```dart
final DLog _log = DLog('FileTag');
...
_log.debug('This is a debug message');
```

or use static methods
```dart
DLog.d('FileTag', 'This is a debug message');
```

or use [DLogMixin]
```dart
class MyClass with DLogMixin {
  @override
  DLog log = DLog('MyClass');
  ...
  void test() {
    logDebug('This is a debug message') // method provided via mixin
  }
}
```

## Limitaions

* Inability to change logging level globaly or disable logger all toghether,
  unless DLog instance is provided via a eg. service locator (like get_it)
* Prints messages to debug console unless specified otherwise.

