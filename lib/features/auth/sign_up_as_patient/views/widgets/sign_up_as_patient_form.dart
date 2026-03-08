import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/view_models/cubit/sign_up_as_patient_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_patient/views/widgets/pick_date_of_birth.dart';
import 'package:care_link/features/auth/sign_up_as_patient/views/widgets/select_patient_gender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/components/custom_text_form_field_with_title.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpAsPatientForm extends StatelessWidget {
  const SignUpAsPatientForm({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignUpAsPatientCubit>();
    final tr = context.tr;
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Name
          CustomTextFormFieldWithTitle(
            title: tr.userName,
            hintText: tr.enterYourUserName,
            prefixIcon: CupertinoIcons.person,
            keyboardType: TextInputType.name,
            controller: cubit.userNameController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          // Email
          CustomTextFormFieldWithTitle(
            title: tr.email,
            hintText: tr.enterYourEmail,
            prefixIcon: CupertinoIcons.mail,
            keyboardType: TextInputType.emailAddress,
            controller: cubit.emailController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          // Phone Number
          CustomTextFormFieldWithTitle(
            title: tr.phoneNumber,
            hintText: tr.enterYourPhoneNumber,
            maxLength: 11,
            prefixIcon: CupertinoIcons.phone,
            keyboardType: TextInputType.phone,
            controller: cubit.phoneController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          // Password
          CustomTextFormFieldWithTitle(
            title: tr.password,
            hintText: tr.enterYourPassword,
            prefixIcon: CupertinoIcons.padlock,
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            controller: cubit.passwordController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          // Date of Birth
          PickDateOfBirth(
            cubit: cubit,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          SelectPatientGender(),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            enableValidator: false,
            title: tr.bloodType,
            hintText: tr.enterBloodType,
            prefixIcon: CupertinoIcons.drop,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              cubit.bloodType = value;
            },
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            enableValidator: false,
            title: tr.height,
            hintText: tr.enterHeightCm,
            prefixIcon: FontAwesomeIcons.ruler,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              cubit.height = double.tryParse(value);
            },
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          // Weight
          CustomTextFormFieldWithTitle(
            enableValidator: false,
            title: tr.weight,
            hintText: tr.enterWeightKg,
            prefixIcon: Icons.scale,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              cubit.weight = double.tryParse(value);
            },
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          // Emergency Contact
          Text(tr.emergencyContact,
              style: AppTextStyles.title18PrimaryColorW500),
          SizedBox(height: SizeConfig.height * 0.005),
          CustomTextFormFieldWithTitle(
            title: tr.contactName,
            hintText: tr.enterContactName,
            prefixIcon: CupertinoIcons.person_2,
            keyboardType: TextInputType.phone,
            controller: cubit.emergencyContactNameController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            title: tr.contactRelationship,
            hintText: tr.enterContactRelationship,
            prefixIcon: CupertinoIcons.reply_all,
            keyboardType: TextInputType.text,
            controller: cubit.emergencyContactrelationshipController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            title: tr.contactNumber,
            hintText: tr.enterContactNumber,
            maxLength: 11,
            prefixIcon: CupertinoIcons.phone_solid,
            keyboardType: TextInputType.phone,
            controller: cubit.emergencyContactPhoneController,
          ),
        ],
      ),
    );
  }
}
