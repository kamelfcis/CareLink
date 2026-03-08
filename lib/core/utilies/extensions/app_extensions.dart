import 'package:flutter/material.dart';

extension AppExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // navigation
  void pushScreen(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void pushReplacementScreen(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  void pushAndRemoveUntilScreen(String routeName) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  void popScreen() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  void popWithResult<T>(T result) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop(result);
    }
  }

  bool canPopScreen() {
    return Navigator.of(this).canPop();
  }
}
