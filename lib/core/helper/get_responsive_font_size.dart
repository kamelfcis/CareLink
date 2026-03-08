import 'package:care_link/core/utilies/sizes/sized_config.dart';

double getResponsiveFontSize({required double fontSize}) {
  double scaleFactor = _getScaleFactor();
  double responsiveFontSize = fontSize * scaleFactor;
  double lowerLimit = fontSize * 0.8;
  double upperLimit = fontSize * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double _getScaleFactor() {
  // Use SizeConfig which is always up-to-date
  double width = SizeConfig.width;
  // Base design width is 375 (iPhone SE / standard design width)
  // Samsung A56 is ~411 dp wide
  if (width < 360) {
    return width / 375;
  } else if (width < 480) {
    return width / 411; // phones — normalized to Samsung A56 width
  } else if (width < 600) {
    return width / 500; // large phones
  } else if (width < 900) {
    return width / 700; // tablets
  } else {
    return width / 1000;
  }
}
