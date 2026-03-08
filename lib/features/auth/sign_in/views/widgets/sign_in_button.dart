import 'package:care_link/core/components/custom_circular_progress_indecator.dart';
import 'package:care_link/core/components/custom_elevated_button.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (p, c) =>
          c is SignInLoading || p is SignInLoading,
      builder: (context, state) {
        return state is SignInLoading
            ? const CustomCircularProgresIndecator()
            : CustomElevatedButton(
                name: context.tr.signIn,
                hPadding: SizeConfig.height * 0.018,
                width: double.infinity,
                onPressed: () =>
                    context.read<SignInCubit>().signIn(),
                backgroundColor: AppColors.kPrimaryColor,
              );
      },
    );
  }
}
