import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class GenderCard extends StatelessWidget {
  const GenderCard({
    super.key,
    this.onTap,
    required this.genderName,
    required this.genderIcon,
    this.isSelected = false,
  });
  final Function()? onTap;
  final String genderName;
  final IconData genderIcon;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected ? AppColors.kPrimaryColor.withOpacity(0.5) : null,
            border: Border.all(
              color: AppColors.kPrimaryColor.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                genderIcon,
                size: SizeConfig.height * 0.05,
                color: isSelected ? Colors.white : AppColors.kPrimaryColor,
              ),
              SizedBox(height: SizeConfig.height * 0.01),
              Text(
                genderName,
                style: isSelected
                    ? AppTextStyles.title16White500
                    : AppTextStyles.title16PrimaryColorW500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
