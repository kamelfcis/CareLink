import 'package:flutter/material.dart';

class SizeConfig {
  static late double width;
  static late double height;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    textScaleFactor = mediaQuery.textScaleFactor.clamp(0.8, 1.2);
  }

  /// Proportional width helper (percentage of screen width)
  static double w(double percentage) => width * percentage;

  /// Proportional height helper (percentage of screen height)
  static double h(double percentage) => height * percentage;
}
