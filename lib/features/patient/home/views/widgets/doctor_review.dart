import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class DoctorReview extends StatelessWidget {
  const DoctorReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            Icons.star,
            size: SizeConfig.width * 0.035,
            color: Colors.amber,
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.01),
        Text(
          '4.9 (120 reviews)',
          style: AppTextStyles.title12WhiteW500,
        ),
      ],
    );
  }
}
