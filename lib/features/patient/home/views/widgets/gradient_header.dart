import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget {
  const GradientHeader({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            AppColors.kPrimaryColor,
            AppColors.kPrimaryColor.withOpacity(0.5),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 0.8],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
