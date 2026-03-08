import 'package:flutter/material.dart';
import 'package:care_link/core/components/custom_icon_button.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialSingUp extends StatelessWidget {
  const SocialSingUp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomIconButton(
          iconSize: SizeConfig.width * 0.07,
          iconColor: Colors.white,
          hPadding: SizeConfig.width * 0.04,
          vPadding: SizeConfig.height * 0.02,
          backgroundColor: AppColors.kPrimaryColor,
          icon: FontAwesomeIcons.facebookF,
          onPressed: () {},
        ),
        CustomIconButton(
                iconSize: SizeConfig.width * 0.07,
                iconColor: Colors.white,
                backgroundColor: AppColors.kPrimaryColor,
                icon: FontAwesomeIcons.google,
                hPadding: SizeConfig.width * 0.04,
                vPadding: SizeConfig.height * 0.02,
                onPressed: () {
                  // context.read<SignUpCubit>().signUpWithGoogle();
                },
              ),
        CustomIconButton(
          iconSize: SizeConfig.width * 0.07,
          iconColor: Colors.white,
          backgroundColor: AppColors.kPrimaryColor,
          icon: Icons.apple,
          hPadding: SizeConfig.width * 0.04,
          vPadding: SizeConfig.height * 0.02,
          onPressed: () {},
        ),
      ],
    );
  }
}
