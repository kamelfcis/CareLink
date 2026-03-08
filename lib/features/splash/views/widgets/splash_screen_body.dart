import 'package:care_link/core/utilies/assets/images/app_images.dart';
import 'package:care_link/features/splash/views/widgets/gradient_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBody(
      child: Center(
        child: Image.asset(AppImages.logoWithoutBackgroundImage)
            .animate()
            .fadeIn(duration: 800.ms, curve: Curves.easeOut)
            .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 700.ms)
            .blur(
                begin: const Offset(8, 8),
                end: const Offset(0, 0),
                duration: 800.ms)
            .move(
                begin: const Offset(0, 40),
                end: const Offset(0, 0),
                duration: 900.ms,
                curve: Curves.easeOutQuad)
            .shake(
              hz: 2,
              offset: const Offset(4, 0),
              duration: 500.ms,
              delay: 900.ms,
            ),
      ),
    );
  }
}

