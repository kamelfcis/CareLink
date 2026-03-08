import 'package:care_link/core/components/custom_circular_progress_indecator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/components/custom_icon_button.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialSignIn extends StatelessWidget {
  const SocialSignIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = SizeConfig.width * 0.055;
    final hPad = SizeConfig.width * 0.035;
    final vPad = SizeConfig.height * 0.015;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomIconButton(
          hPadding: hPad,
          vPadding: vPad,
          iconSize: iconSize,
          backgroundColor: AppColors.kPrimaryColor,
          iconColor: Colors.white,
          icon: FontAwesomeIcons.facebookF,
          onPressed: () {},
        ),
        BlocBuilder<SignInCubit, SignInState>(
          buildWhen: (previous, current) =>
              current is SignInWithGoogleLoading ||
              previous is SignInWithGoogleLoading,
          builder: (context, state) {
            return state is SignInWithGoogleLoading
                ? const CustomCircularProgresIndecator()
                : CustomIconButton(
                    hPadding: hPad,
                    vPadding: vPad,
                    iconSize: iconSize,
                    backgroundColor: AppColors.kPrimaryColor,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.google,
                  );
          },
        ),
        CustomIconButton(
          hPadding: hPad,
          vPadding: vPad,
          iconSize: iconSize,
          backgroundColor: AppColors.kPrimaryColor,
          iconColor: Colors.white,
          icon: Icons.apple,
          onPressed: () {},
        ),
      ],
    );
  }
}
