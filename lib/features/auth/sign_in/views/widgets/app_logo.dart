import 'package:care_link/core/utilies/assets/images/app_images.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = SizeConfig.width * 0.28;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.height * 0.015,
        horizontal: SizeConfig.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          AppImages.logoWithoutBackgroundImage,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
