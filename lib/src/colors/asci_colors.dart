/*
 * Created on Tue Oct 11 2022
 *
 * Copyright (c) 2022 Wojciech Plesiak
 *
 * [[ PACKAGE - DF_LOGGER ]]
 */

enum AsciColor {
  reset,
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  brightBlack,
  brightRed,
  brightGreen,
  brightYellow,
  brightBlue,
  brightMegenta,
  brightCyan,
  brightWhite,
}

extension AsciColorExt on AsciColor {
  int get _code {
    switch (this) {
      case AsciColor.reset:
        return 0;
      case AsciColor.black:
        return 30;
      case AsciColor.red:
        return 31;
      case AsciColor.green:
        return 32;
      case AsciColor.yellow:
        return 33;
      case AsciColor.blue:
        return 34;
      case AsciColor.magenta:
        return 35;
      case AsciColor.cyan:
        return 36;
      case AsciColor.white:
        return 37;
      case AsciColor.brightBlack:
        return 90;
      case AsciColor.brightRed:
        return 91;
      case AsciColor.brightGreen:
        return 92;
      case AsciColor.brightYellow:
        return 93;
      case AsciColor.brightBlue:
        return 94;
      case AsciColor.brightMegenta:
        return 95;
      case AsciColor.brightCyan:
        return 96;
      case AsciColor.brightWhite:
        return 97;
    }
  }

  String get color {
    return "\x1B[${_code}m";
  }

  String colorize(String msg) {
    return "$color$msg${AsciColor.reset.color}";
  }
}
