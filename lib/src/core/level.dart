/// Copyright (c) 2025 Wojciech Plesiak

import '../colors/asci_colors.dart';

/// Log levels
enum Level {
  trace,
  verbose,
  debug,
  info,
  notice,
  warning,
  alert,
  error,
  custom,
}

/// Dart enums are very basic and do not allow holding data.
/// Adding an extension function like this is a well working workaround.
extension LevelExt on Level {
  String get letter => switch (this) {
        Level.trace => 'T',
        Level.verbose => 'V',
        Level.debug => 'D',
        Level.info => 'I',
        Level.notice => 'N',
        Level.warning => 'W',
        Level.alert => 'A',
        Level.error => 'E',
        Level.custom => 'C',
      };

  AsciColor get color => switch (this) {
        Level.trace => AsciColor.brightBlack,
        Level.verbose => AsciColor.brightWhite,
        Level.debug => AsciColor.brightGreen,
        Level.info => AsciColor.brightBlue,
        Level.notice => AsciColor.brightCyan,
        Level.warning => AsciColor.brightYellow,
        Level.alert => AsciColor.brightMegenta,
        Level.error => AsciColor.brightRed,
        Level.custom => AsciColor.brightBlack, // not used
      };

  /// higher number = higher importance
  int get importance => switch (this) {
        Level.trace => 0,
        Level.verbose => 1,
        Level.debug => 2,
        Level.info => 3,
        Level.notice => 4,
        Level.warning => 5,
        Level.alert => 6,
        Level.error => 7,
        Level.custom => 8,
      };
}
