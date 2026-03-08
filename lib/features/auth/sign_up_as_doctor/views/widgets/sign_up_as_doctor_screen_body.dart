import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/have_account_or_not.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/or_sign_with.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/view_models/cubit/sign_up_as_doctor_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/pick_doctor_image.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/sign_up_as_doctor_button.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/sign_up_as_doctor_form.dart';
import 'package:care_link/features/auth/sign_up_as_patient/views/widgets/social_sign_up.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpAsDoctorScreenBody extends StatelessWidget {
  const SignUpAsDoctorScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocListener<SignUpAsDoctorCubit, SignUpAsDoctorState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.pushAndRemoveUntilScreen(RouteNames.signInScreen);
          CustomQuickAlert.success(
            title: tr.success,
            message: tr.accountCreatedSuccess,
          );
        } else if (state is SignUpFailure) {
          CustomQuickAlert.error(
            title: tr.error,
            message: state.errorMessage,
          );
        } else if (state is SelectImage) {
          CustomQuickAlert.warning(
            title: tr.warning,
            message: tr.pleaseSelectImage,
          );
        }
      },
      child: GradientHeader(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.height * 0.02),
                  PickDoctorImage(),
                  SizedBox(height: SizeConfig.height * 0.02),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 0.05,
                      vertical: SizeConfig.height * 0.03,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          tr.createAccount,
                          style: AppTextStyles.title24PrimaryColorW500,
                        ),
                        SizedBox(height: 4),
                        Text(
                          tr.fillDetailsToGetStarted,
                          style: AppTextStyles.title14Grey,
                        ),
                        SizedBox(height: SizeConfig.height * 0.025),
                        const SignUpAsDoctorForm(),
                        SizedBox(height: SizeConfig.height * 0.025),
                        SignUpAsDoctorButton(),
                        const OrSignWith(),
                        const SocialSingUp(),
                        SizedBox(height: SizeConfig.height * 0.015),
                        HaveAccountOrNot(
                          title: "${tr.alreadyHaveAccount} ",
                          value: tr.signIn,
                          onPressed: () => context.popScreen(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
