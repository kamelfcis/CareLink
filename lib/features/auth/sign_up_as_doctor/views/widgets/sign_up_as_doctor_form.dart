import 'package:care_link/core/components/custom_circular_progress_indecator.dart';
import 'package:care_link/core/components/custom_drop_down_button_form_field.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/view_models/cubit/sign_up_as_doctor_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/custom_failure_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/components/custom_text_form_field_with_title.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';

class SignUpAsDoctorForm extends StatelessWidget {
  const SignUpAsDoctorForm({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignUpAsDoctorCubit>();
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
          BlocBuilder<SignUpAsDoctorCubit, SignUpAsDoctorState>(
            buildWhen: (p, c) =>
                c is GetDoctorSpecialtiesSuccess ||
                c is GetDoctorSpecialtiesLoading ||
                c is GetDoctorSpecialtiesFailure,
            builder: (context, state) {
              if (state is GetDoctorSpecialtiesLoading) {
                return CustomCircularProgresIndecator();
              } else if (state is GetDoctorSpecialtiesFailure) {
                return CustomFailureMesage(
                  errorMessage: state.errorMessage,
                );
              }
              return CustomDropDownButtonFormField(
                title: tr.specialization,
                hintText: tr.enterYourSpecialization,
                items: cubit.doctorSpecialties,
                itemLabelBuilder: ((item) => item.name),
                onChanged: (value) {
                  cubit.sselectedSpecialtyId = value?.id;
                },
              );
            },
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            title: tr.bio,
            hintText: tr.enterYourBio,
            prefixIcon: Icons.description,
            keyboardType: TextInputType.text,
            controller: cubit.bioController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          CustomTextFormFieldWithTitle(
            title: tr.hospitalName,
            hintText: tr.enterHospitalName,
            prefixIcon: Icons.local_hospital,
            keyboardType: TextInputType.text,
            controller: cubit.hospitalController,
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
        ],
      ),
    );
  }
}
