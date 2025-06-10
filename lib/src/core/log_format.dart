/// Copyright (c) 2025 Wojciech Plesiak

/// Defines the format of the log message.
class LogFormat {
  /// Placeholders for date, time, log level, tag and message.
  static const d = '<D>';
  static const t = '<T>';
  static const l = '<L>';
  static const p = '<P>';
  static const m = '<M>';

  /// Default format: "date time logLevel/tag: message", eg "2025-01-22 23:56:35.301917 I/ClassTag: This is an info message"
  static const defaultFormat = '$d $t $l/$p: $m';

  static const noDateFormat = '$t $l/$p: $m';

  static const noDateTimeFormat = '$l/$p: $m';

  final String logFormat;

  const LogFormat([this.logFormat = defaultFormat]);

  const LogFormat.noDate() : logFormat = noDateFormat;

  const LogFormat.noDateTime() : logFormat = noDateTimeFormat;

  /// Formats the log message according to the `logFormat` string.
  String format(String date, String time, String logLevel, String prefix, String msg) =>
      logFormat.replaceAll(d, date).replaceAll(t, time).replaceAll(l, logLevel).replaceAll(p, prefix).replaceAll(m, msg);
}
