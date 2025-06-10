/// Copyright (c) 2025 Wojciech Plesiak

// ignore_for_file: avoid_print

import '../colors/asci_colors.dart';
import '../core/core.dart';
import '../logger/dlog.dart';

const _tag = 'ClassTag';
const _group = 'CT';

final DLog _log = DLog(
  _tag,
  config: DLogConfig.defaultConfig.copyWith(
    logger: (coloredMessage, logLine) => print(coloredMessage),
    // fasadeMap: {}, // uncomment to use base asci colors
  ),
);

/// Run with `dart df_logger/lib/src/example/main.dart`
void main(List<String> args) {
  print('------ PRINTING LOG MESSAGES WITH TAG ONLY ------ ');
  _log.trace('This is a trace message');
  _log.verbose('This is a verbose message');
  _log.debug('This is a debug message');
  _log.info('This is an info message');
  _log.notice('This is a notice message');
  _log.warning('This is a warning message');
  _log.alert('This is an alert message');
  _log.error('This is an error message');
  _log.custom('This is a custom message');

  print('------ PRINTING LOG MESSAGES WITH BACKGROUND ------ ');
  _log.trace('This is a trace message', fasade: Fasade.swapped());
  _log.verbose('This is a verbose message', fasade: Fasade.swapped());
  _log.debug('This is a debug message', fasade: Fasade.swapped());
  _log.info('This is an info message', fasade: Fasade.swapped());
  _log.notice('This is a notice message', fasade: Fasade.swapped());
  _log.warning('This is a warning message', fasade: Fasade.swapped());
  _log.alert('This is an alert message', fasade: Fasade.swapped());
  _log.error('This is an error message', fasade: Fasade.swapped());
  _log.custom('This is a custom message', fasade: Fasade.swapped());

  print('\n------ PRINTING LOG MESSAGES WITH TAG & GROUP ------ ');
  final glog = DLog(
    _tag,
    group: 'CT',
    config: DLogConfig.defaultConfig.copyWith(
      logger: (coloredMessage, logLine) => print(coloredMessage),
      // fasadeMap: {}, // uncomment to use base asci colors
    ),
  );
  glog.trace('This is a trace message in a group');
  glog.verbose('This is a verbose message in a group');
  glog.debug('This is a debug message in a group');
  glog.info('This is an info message in a group');
  glog.notice('This is a notice message in a group');
  try {
    throw Exception('exception');
  } catch (e, stackTrace) {
    glog.warning('This is a warning message in a group with exception', error: e, stackTrace: stackTrace);
    glog.alert('This is an alert message in a group with exception', error: e, stackTrace: stackTrace);
    glog.error('This is an error message in a group with exception', error: e, stackTrace: stackTrace);
    glog.custom('This is a custom message in a group with exception', error: e, stackTrace: stackTrace);
  }

  /// Static access
  DLog.t(_tag, 'This is a trace message via DLog.t');
  DLog.v(_tag, 'This is a verbose message via DLog.v');
  DLog.d(_tag, 'This is a debug message via DLog.d');
  DLog.i(_tag, 'This is an info message via DLog.i in a group', group: _group);
  DLog.n(_tag, 'This is a notice message via DLog.n');
  DLog.w(_tag, 'This is a warning message via DLog.w');
  DLog.a(_tag, 'This is an alert message via DLog.a');
  DLog.e(_tag, 'This is an error message via DLog.e in a group', group: _group);
  DLog.c(_tag, 'This is a custom message via DLog.c in a group', group: _group);

  print('\n------ PRINTING ALL AVAILABLE COLORS ------ ');
  // Reorder by pairing standard with corresponding bright variant
  final reorderedColors = [
    for (int i = 0; i < AsciColor.values.length / 2; i++) ...[AsciColor.values[i], AsciColor.values[i + AsciColor.values.length ~/ 2]]
  ];
  for (var color in reorderedColors) {
    final message = color.colorize('hello world in $color');

    print(message);
  }

  print('\n------ RGB ALWAYS WINS ------ ');

  // RGB: Red (255, 0, 0)
  print('\x1B[38;2;255;0;0mThis is bright red\x1B[0m');

  // RGB: Green (0, 255, 0)
  print('\x1B[38;2;0;255;0mThis is bright green\x1B[0m');

  // RGB: Blue (0, 0, 255)
  print('\x1B[38;2;17;216;230mThis is bright blue\x1B[0m');

  print('\x1B[38;2;255;165;0mWe have a winner\x1B[0m');
  print('\x1B[48;2;255;165;0mWe have a winner\x1B[0m');

  // Foreground: orange (RGB: 255, 165, 0), Background: light blue (RGB: 173, 216, 230)
  print('\x1B[38;2;255;165;0;48;2;173;216;230mOrange text on light blue background\x1B[0m');
}
