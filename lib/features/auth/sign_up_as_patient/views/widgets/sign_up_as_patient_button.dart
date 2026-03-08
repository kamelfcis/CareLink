import 'package:care_link/core/components/custom_circular_progress_indecator.dart';
import 'package:care_link/core/components/custom_elevated_button.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_up_as_patient/view_models/cubit/sign_up_as_patient_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpAsPatientCubit, SignUpAsPatientState>(
      buildWhen: (p, c) => c is SignUpLoading || p is SignUpLoading,
      builder: (context, state) {
        return state is SignUpLoading
            ? const CustomCircularProgresIndecator()
            : CustomElevatedButton(
                name: context.tr.signUp,
                width: double.infinity,
                height: SizeConfig.height * 0.07,
                onPressed: () {
                  context.read<SignUpAsPatientCubit>().signUp();
                },
                backgroundColor: AppColors.kPrimaryColor,
              );
      },
    );
  }
}
