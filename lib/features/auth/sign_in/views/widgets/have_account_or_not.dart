import 'package:flutter/material.dart';
import 'package:care_link/core/components/custom_text_button.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';

class HaveAccountOrNot extends StatelessWidget {
  const HaveAccountOrNot({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
  });
  final String title, value;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.title14Black,
          ),
          CustomTextButton(
            title: value,
            style: AppTextStyles.title16PrimaryColorW500,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
