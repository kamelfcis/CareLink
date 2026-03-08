import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GradientBody extends StatelessWidget {
  const GradientBody({super.key, required this.child, this.xStop=0.001, this.yStop=.23});
  final Widget child;
  final double? xStop;
  final double? yStop;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kPrimaryColor,
            Colors.white,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft, 
          stops: [xStop!, yStop!],
        ),
      ),
      child: child,
    );
  }
}
