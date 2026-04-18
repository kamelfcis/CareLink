import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class DoctorImage extends StatelessWidget {
  const DoctorImage({
    super.key,
    this.doctorImage,
  });

  final String? doctorImage;

  @override
  Widget build(BuildContext context) {
    final radius = SizeConfig.width * 0.09;
    final url = doctorImage?.trim();
    final hasImage = url != null && url.isNotEmpty;

    return Positioned(
      top: 0,
      left: SizeConfig.width * 0.04,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: radius - 3,
          backgroundColor: AppColors.kPrimaryLight,
          backgroundImage:
              hasImage ? NetworkImage(url) : null,
          child: hasImage
              ? null
              : Icon(
                  Icons.person_rounded,
                  size: radius * 1.1,
                  color: AppColors.kPrimaryDark,
                ),
        ),
      ),
    );
  }
}
