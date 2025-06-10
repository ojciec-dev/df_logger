/// Copyright (c) 2025 Wojciech Plesiak

import 'core.dart';

/// Log line representation.
class LogLine {
  /// Required log level.
  final Level level;

  /// Log message.
  final String msg;

  /// Optional tag for log message.
  final String? tag;

  /// Optional group for log message.
  final String? group;

  /// Colors of log message. If not provided, default colors will be used.
  final Fasade? fasade;

  /// Optional log format. If not provided, default format will be used.
  final LogFormat? logFormat;

  /// Optional error object.
  final dynamic error;

  /// Optional stack trace.
  final StackTrace? stackTrace;

  /// Date of log message. Calculated from [DateTime.now()] when log message is created.
  final String date;

  /// Time of log message. Calculated from [DateTime.now()] when log message is created.
  final String time;

  /// Prefix of log message. Createf from [tag] and [group] when log message is created.
  final String prefix;

  /// Keeps created formatted message.
  String? _formattedMessage;

  LogLine(this.level, this.msg, {this.tag, this.group, this.fasade, this.logFormat, this.error, this.stackTrace})
      : date = DateTime.now().toString().split(' ')[0],
        time = DateTime.now().toString().split(' ')[1],
        prefix = generatePrefix(tag, group);

  String get formattedMessage {
    if (_formattedMessage != null) {
      return _formattedMessage!;
    }
    final formatter = logFormat ?? DLogDefaults.logFormat;
    _formattedMessage = formatter.format(date, time, level.letter, prefix, msg);
    return _formattedMessage!;
  }

  LogLine copyWith({
    Level? level,
    String? msg,
    String? tag,
    String? group,
    Fasade? fasade,
    LogFormat? logFormat,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return LogLine(
      level ?? this.level,
      msg ?? this.msg,
      tag: tag ?? this.tag,
      group: group ?? this.group,
      fasade: fasade ?? this.fasade,
      logFormat: logFormat ?? this.logFormat,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  toString() => 'LogLine($date, $time, $level, $prefix, $msg, $error, $stackTrace)';

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
