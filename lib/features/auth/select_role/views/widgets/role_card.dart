import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.height * 0.02,
          horizontal: SizeConfig.width * 0.04,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.kPrimaryColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.kPrimaryColor.withOpacity(0.25),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: SizeConfig.width * 0.14,
              color:
                  isSelected ? AppColors.kPrimaryColor : Colors.grey.shade700,
            ),
            SizedBox(width: SizeConfig.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.title18BlackBold.copyWith(
                      color:
                          isSelected ? AppColors.kPrimaryColor : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.title14Grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}









