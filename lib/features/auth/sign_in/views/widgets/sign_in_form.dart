import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/components/custom_text_form_field_with_title.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignInCubit>();
    final tr = context.tr;
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          CustomTextFormFieldWithTitle(
            title: tr.email,
            hintText: tr.enterYourEmail,
            prefixIcon: CupertinoIcons.phone,
            controller: cubit.emailController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            title: tr.password,
            hintText: tr.enterYourPassword,
            controller: cubit.passwordController,
            prefixIcon: CupertinoIcons.padlock,
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
