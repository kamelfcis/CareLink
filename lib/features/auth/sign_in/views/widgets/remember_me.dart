import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/features/auth/forgot_password/views/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:care_link/core/components/custom_text_button.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';

class RememberMeAndForgotPassword extends StatelessWidget {
  const RememberMeAndForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: AppColors.kPrimaryColor)),
            activeColor: AppColors.kPrimaryColor,
            checkColor: AppColors.kPrimaryColor,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            tr.rememberMe,
            style: AppTextStyles.title12BlackColorW400,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Flexible(
          child: CustomTextButton(
            title: tr.forgotPassword,
            style: AppTextStyles.title14PrimaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
