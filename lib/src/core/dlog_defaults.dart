/// Copyright (c) 2025 Wojciech Plesiak

import '../colors/dlog_color.dart';
import 'fasade.dart';
import 'level.dart';
import 'log_format.dart';

abstract class DLogDefaults {
  static const logFormat = LogFormat();

  static const DLogColor traceColor = DLogColor.fromARGB(255, 163, 174, 182);
  static const DLogColor verboseColor = DLogColor.fromARGB(255, 208, 230, 249);
  static const DLogColor debugColor = DLogColor.fromARGB(255, 22, 231, 22);
  static const DLogColor infoColor = DLogColor.fromARGB(255, 67, 154, 252);
  static const DLogColor noticeColor = DLogColor.fromARGB(255, 0, 255, 255);
  static const DLogColor warningColor = DLogColor.fromARGB(255, 255, 167, 38);
  static const DLogColor alertColor = DLogColor.fromARGB(255, 248, 84, 248);
  static const DLogColor errorColor = DLogColor.fromARGB(255, 239, 93, 83);
  static const DLogColor customColor = DLogColor.fromARGB(255, 255, 255, 36);

  static const defaultFasades = {
    Level.trace: Fasade(
      fgColor: traceColor,
    ),
    Level.verbose: Fasade(
      fgColor: verboseColor,
    ),
    Level.debug: Fasade(
      fgColor: debugColor,
    ),
    Level.info: Fasade(
      fgColor: infoColor,
    ),
    Level.notice: Fasade(
      fgColor: noticeColor,
    ),
    Level.warning: Fasade(
      fgColor: warningColor,
    ),
    Level.alert: Fasade(
      fgColor: alertColor,
    ),
    Level.error: Fasade(
      fgColor: errorColor,
    ),
    Level.custom: Fasade(
      fgColor: customColor,
    ),
  };

  static DLogColor colorFor(Level level) => defaultFasades[level]?.fgColor ?? traceColor;
}
