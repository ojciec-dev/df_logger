/// (c) Dartfort. Confidential and proprietary.

import 'package:flutter/material.dart';

import '../core/fasade.dart';
import '../logger/dlog.dart';

extension WidgetExt on Widget {
  static DLog Function(String tag, String? group)? _dlogBuilder;

  /// To use DLog Widget extension methods, first you need to set the DLog builder. Do it once from the root widget.
  setDLogBuilder(DLog Function(String tag, String? group) dlogBuilder) {
    _dlogBuilder = dlogBuilder;
  }

  bool get isDLogBuilderSet => _dlogBuilder != null;

  /// Prints the name of this widgets to the debug console.
  void get printMe => printn('hello');

  /// Prints trace level message to the debug console using Widget name as a log tag.
  void printt(String message, {String? group, Fasade? fasade}) => _dlogBuilder?.call('$this', group).trace(message, fasade: fasade);

  /// Prints verbose level message to the debug console using Widget name as a log tag.
  void printv(String message, {String? group, Fasade? fasade}) => _dlogBuilder?.call('$this', group).verbose(message, fasade: fasade);

  /// Prints debug level message to the debug console using Widget name as a log tag.
  void printd(String message, {String? group, Fasade? fasade}) => _dlogBuilder?.call('$this', group).debug(message, fasade: fasade);

  /// Prints info level message to the debug console using Widget name as a log tag.
  void printi(String message, {String? group, Fasade? fasade}) => _dlogBuilder?.call('$this', group).info(message, fasade: fasade);

  /// Prints notice level message to the debug console using Widget name as a log tag.
  void printn(String message, {String? group, Fasade? fasade}) => _dlogBuilder?.call('$this', group).notice(message, fasade: fasade);

  /// Prints warning level message with optional exception to the debug console using Widget name as a log tag.
  void printw(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      _dlogBuilder?.call('$this', group).warning(message, fasade: fasade, error: error, stackTrace: stackTrace);

  /// Prints alert level message with optional exception to the debug console using Widget name as a log tag.
  void printa(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      _dlogBuilder?.call('$this', group).alert(message, fasade: fasade, error: error, stackTrace: stackTrace);

  /// Prints error level message with optional exception to the debug console using Widget name as a log tag.
  void printe(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      _dlogBuilder?.call('$this', group).error(message, fasade: fasade, error: error, stackTrace: stackTrace);

  /// Prints custom level message with optional exception to the debug console using Widget name as a log tag.
  void printc(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      _dlogBuilder?.call('$this', group).custom(message, fasade: fasade, error: error, stackTrace: stackTrace);

  void printp(String message, {String? group, Fasade? fasade}) => printc('[BUTTON PRESS] $message', fasade: fasade);
}

extension StateExt on State {
  /// Prints the name of this widgets to the debug console.
  void get printMe => printd('hello state');

  /// Prints trace level message to the debug console using Widget name as a log tag.
  void printt(String message, {String? group, Fasade? fasade}) => WidgetExt._dlogBuilder?.call('$this', group).trace(message, fasade: fasade);

  /// Prints verbose level message to the debug console using Widget name as a log tag.
  void printv(String message, {String? group, Fasade? fasade}) => WidgetExt._dlogBuilder?.call('$this', group).verbose(message, fasade: fasade);

  /// Prints debug level message to the debug console using Widget name as a log tag.
  void printd(String message, {String? group, Fasade? fasade}) => WidgetExt._dlogBuilder?.call('$this', group).debug(message, fasade: fasade);

  /// Prints info level message to the debug console using Widget name as a log tag.
  void printi(String message, {String? group, Fasade? fasade}) => WidgetExt._dlogBuilder?.call('$this', group).info(message, fasade: fasade);

  /// Prints notice level message to the debug console using Widget name as a log tag.
  void printn(String message, {String? group, Fasade? fasade}) => WidgetExt._dlogBuilder?.call('$this', group).notice(message, fasade: fasade);

  /// Prints warning level message with optional exception to the debug console using Widget name as a log tag.
  void printw(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      WidgetExt._dlogBuilder?.call('$this', group).warning(message, fasade: fasade, error: error, stackTrace: stackTrace);

  /// Prints alert level message with optional exception to the debug console using Widget name as a log tag.
  void printa(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      WidgetExt._dlogBuilder?.call('$this', group).alert(message, fasade: fasade, error: error, stackTrace: stackTrace);

  /// Prints error level message with optional exception to the debug console using Widget name as a log tag.
  void printe(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      WidgetExt._dlogBuilder?.call('$this', group).error(message, fasade: fasade, error: error, stackTrace: stackTrace);

  /// Prints custom level message with optional exception to the debug console using Widget name as a log tag.
  void printc(String message, {String? group, Fasade? fasade, dynamic error, StackTrace? stackTrace}) =>
      WidgetExt._dlogBuilder?.call('$this', group).custom(message, fasade: fasade, error: error, stackTrace: stackTrace);
}
