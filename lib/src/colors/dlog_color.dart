/// Copyright (c) 2025 Wojciech Plesiak

class DLogColor {
  final int value;

  // Extract ARGB values
  int get alpha => (value >> 24) & 0xFF;
  int get red => (value >> 16) & 0xFF;
  int get green => (value >> 8) & 0xFF;
  int get blue => value & 0xFF;

  const DLogColor(this.value);

  const DLogColor.fromARGB(int a, int r, int g, int b) : value = (((a & 0xff) << 24) | ((r & 0xff) << 16) | ((g & 0xff) << 8) | (b & 0xff));

  @override
  String toString() => 'DLogColor($alpha, $red, $green, $blue)';
}
