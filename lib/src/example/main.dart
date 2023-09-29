// ignore_for_file: avoid_print

/*
 * Created on Mon Dec 05 2022
 *
 * Copyright (c) 2022 Wojciech Plesiak
 *
 * [[ PACKAGE - DF_LOGGER ]]
 */

import 'package:df_logger/df_logger.dart';

import '../colors/asci_colors.dart';

const _tag = 'ClassTag';
const _group = 'CT';

final DLog _log = DLog(_tag, logger: _printMessage);

/// Run with `dart df_logger/lib/src/example/main.dart`
void main(List<String> args) {
  print('\n------ PRINTING LOG MESSAGES WITH TAG ONLY ------ ');
  _log.verbose('This is a verbose message');
  _log.debug('This is a debug message');
  _log.info('This is an info message');
  _log.warning('This is a warning message');
  _log.error('This is an error message');
  _log.error('This is an error message', Exception('This is a message from an exception'));

  print('\n------ PRINTING LOG MESSAGES WITH TAG & GROUP ------ ');
  final glog = DLog(_tag, group: 'CT', logger: _printMessage);
  glog.verbose('This is a verbose message in a group');
  glog.debug('This is a debug message in a group');
  glog.info('This is an info message in a group');
  glog.warning('This is a warning message in a group with exception', Exception('warning exception'));
  glog.error('This is an error message in a group with exception', Exception('error exception'));

  /// Static access
  DLog.v(_tag, 'This is a verbose message via DLog.d');
  DLog.d(_tag, 'This is a debug message via DLog.d');
  DLog.i(_tag, 'This is an info message via DLog.i in a group', group: _group);
  DLog.w(_tag, 'This is a warning message via DLog.w');
  DLog.e(_tag, 'This is an error message via DLog.e in a group', group: _group);

  /// All colors
  print('\n------ ALL AVAILABLE COLORS ------ ');
  for (var color in AsciColor.values) {
    _printMessage(color.colorize('$color'));
  }

  // _printMessage(AsciColor.)
}

void _printMessage(String message) => print(message);
