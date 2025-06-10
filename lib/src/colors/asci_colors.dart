/// Copyright (c) 2025 Wojciech Plesiak

import 'dlog_color.dart';

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
  rgb,
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
      case AsciColor.rgb:
        return 30;
    }
  }

  String get color {
    return '\x1B[${_code}m';
  }

  String colorize(String msg) {
    return '$color$msg${AsciColor.reset.color}';
  }

  /// Colorize the message with RGB color.
  ///
  /// Example:
  /// print('\x1B[38;2;255;165;0m Orange foreground \x1B[0m');
  /// print('\x1B[48;2;255;165;0m Orange background \x1B[0m');
  /// print('\x1B[38;2;255;165;0m\x1B[48;2;173;216;230m Orange text on light blue background \x1B[0m');
  String rgbColorize(String msg, [DLogColor? fbColor, DLogColor? bgColor]) {
    if (fbColor == null && bgColor == null) {
      return colorize(msg);
    }

    var fg = fbColor != null ? '\x1B[38;2;${fbColor.red};${fbColor.green};${fbColor.blue}m' : '';
    var bg = bgColor != null ? '\x1B[48;2;${bgColor.red};${bgColor.green};${bgColor.blue}m' : '';

    return '$bg$fg$msg\x1B[0m';
  }
}

extension E on double {
  int get channel => (this * 255.0).round();
}
