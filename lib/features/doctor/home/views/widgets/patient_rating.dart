import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class PatientRating extends StatelessWidget {
  const PatientRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(
            5,
            (starIndex) => Icon(
              starIndex < 4 ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: SizeConfig.width * 0.04,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.02,
            vertical: SizeConfig.height * 0.005,
          ),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "4/5",
            style: AppTextStyles.title12PrimaryColorW500,
          ),
        ),
      ],
    );
  }
}
