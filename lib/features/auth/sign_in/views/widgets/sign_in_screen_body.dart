import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/app_logo.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/have_account_or_not.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/or_sign_with.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/remember_me.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/sign_in_button.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/sign_in_form.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/social_sign_in.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/app_route/route_names.dart';

class SignInScreenBody extends StatelessWidget {
  const SignInScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          context.pushReplacementScreen(state.route);
          CustomQuickAlert.success(
            title: tr.success,
            message: tr.signedInSuccess,
          );
        }
        if (state is SignInFailure) {
          CustomQuickAlert.error(
            title: tr.error,
            message: state.message,
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
                  SizedBox(height: SizeConfig.height * 0.03),
                  AppLogo(),
                  SizedBox(height: SizeConfig.height * 0.03),
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
                          tr.welcomeBack,
                          style: AppTextStyles.title24PrimaryColorW500,
                        ),
                        SizedBox(height: 4),
                        Text(
                          tr.signInToContinue,
                          style: AppTextStyles.title14Grey,
                        ),
                        SizedBox(height: SizeConfig.height * 0.025),
                        const SignInForm(),
                        SizedBox(height: SizeConfig.height * 0.008),
                        const RememberMeAndForgotPassword(),
                        SizedBox(height: SizeConfig.height * 0.02),
                        SignInButton(),
                        const OrSignWith(),
                        const SocialSignIn(),
                        SizedBox(height: SizeConfig.height * 0.02),
                        HaveAccountOrNot(
                          title: "${tr.dontHaveAccount} ",
                          value: tr.signUp,
                          onPressed: () =>
                              context.pushScreen(RouteNames.selectRoleScreen),
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
