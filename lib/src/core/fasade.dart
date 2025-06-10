/// Copyright (c) 2025 Wojciech Plesiak

import '../colors/dlog_color.dart';

/// Fasade class for coloring log messages.
class Fasade {
  final DLogColor? fgColor;
  final DLogColor? bgColor;

  /// Swap fg and bg colors.
  final bool swapped;

  const Fasade.swapped({
    this.fgColor,
    this.bgColor,
  }) : swapped = true;

  const Fasade({
    this.fgColor,
    this.bgColor,
    this.swapped = false,
  });

  /// Returns true if any color is set.
  bool get hasColor => fgColor != null || bgColor != null;
}
