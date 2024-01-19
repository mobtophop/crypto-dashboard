import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color placeholder = Color.fromARGB(255, 236, 231, 230);

  /// Main
  static const Color bgOffWhite = Color.fromARGB(255, 250, 250, 250);
  static const Color fgGreyDark = Color.fromARGB(255, 46, 45, 42);
  static const Color fgGrey = Color.fromARGB(255, 178, 175, 166);
  static const Color fgGreyLight = Color.fromARGB(255, 234, 235, 236);
  static const Color fgGreyLight1 = Color.fromARGB(255, 194, 194, 194);
  static const Color fgSelection = Color.fromARGB(255, 254, 112, 102);

  /// Price delta
  static const Color fgPositiveDelta = Color.fromARGB(255, 21, 201, 43);
  static const Color bgPositiveDelta = Color.fromARGB(255, 231, 254, 234);
  static const Color fgNegativeDelta = Color.fromARGB(255, 231, 12, 12);
  static const Color bgNegativeDelta = Color.fromARGB(255, 253, 245, 245);
}
