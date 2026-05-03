import 'dart:io';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:care_link/core/components/custom_text_form_field_with_title.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/patient/profile/view_models/cubit/edit_profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatelessWidget {
  final PatientModel patient;

  const EditProfileScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(patient),
      child: const _EditProfileBody(),
    );
  }
}

class _EditProfileBody extends StatelessWidget {
  const _EditProfileBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    final tr = context.tr;

    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr.profileUpdatedSuccess),
              backgroundColor: AppColors.kPrimaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, state.updatedPatient);
        } else if (state is EditProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditProfileLoading;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: AppColors.kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Text(tr.editProfile, style: AppTextStyles.title18WhiteW500),
            centerTitle: true,
            actions: [
              if (isLoading)
                Padding(
                  padding: EdgeInsets.all(SizeConfig.width * 0.035),
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  ),
                )
              else
                TextButton(
                  onPressed: () => cubit.saveProfile(),
                  child:
                      Text(tr.save, style: AppTextStyles.title16WhiteBold),
                ),
            ],
          ),
          body: Form(
            key: cubit.formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.04,
                vertical: SizeConfig.height * 0.02,
              ),
              children: [
                _ProfileImagePicker(cubit: cubit),
                SizedBox(height: SizeConfig.height * 0.03),

                // ─── Personal Information ───
                _SectionCard(
                  title: tr.personalInformation,
                  icon: Icons.person_outline,
                  children: [
                    CustomTextFormFieldWithTitle(
                      title: tr.fullName,
                      hintText: tr.enterYourFullName,
                      prefixIcon: CupertinoIcons.person,
                      keyboardType: TextInputType.name,
                      controller: cubit.nameController,
                    ),
                    SizedBox(height: SizeConfig.height * 0.015),
                    CustomTextFormFieldWithTitle(
                      title: tr.phoneNumber,
                      hintText: tr.enterYourPhoneNumber,
                      prefixIcon: CupertinoIcons.phone,
                      keyboardType: TextInputType.phone,
                      controller: cubit.phoneController,
                      maxLength: 11,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.height * 0.02),

                // ─── Medical Information ───
                _SectionCard(
                  title: tr.basicInformation,
                  icon: Icons.medical_information_outlined,
                  children: [
                    _GenderSelector(cubit: cubit),
                    SizedBox(height: SizeConfig.height * 0.015),
                    _DateOfBirthPicker(cubit: cubit),
                    SizedBox(height: SizeConfig.height * 0.015),
                    _BloodTypeDropdown(cubit: cubit),
                    SizedBox(height: SizeConfig.height * 0.015),
                    CustomTextFormFieldWithTitle(
                      enableValidator: false,
                      title: tr.weight,
                      hintText: tr.enterWeightKg,
                      prefixIcon: Icons.scale,
                      keyboardType: TextInputType.number,
                      controller: cubit.weightController,
                    ),
                    SizedBox(height: SizeConfig.height * 0.015),
                    CustomTextFormFieldWithTitle(
                      enableValidator: false,
                      title: tr.height,
                      hintText: tr.enterHeightCm,
                      prefixIcon: FontAwesomeIcons.ruler,
                      keyboardType: TextInputType.number,
                      controller: cubit.heightController,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.height * 0.02),

                // ─── Emergency Contact ───
                _SectionCard(
                  title: tr.emergencyContact,
                  icon: Icons.emergency_outlined,
                  children: [
                    CustomTextFormFieldWithTitle(
                      title: tr.contactName,
                      hintText: tr.enterContactName,
                      prefixIcon: CupertinoIcons.person_2,
                      keyboardType: TextInputType.name,
                      controller: cubit.emergencyNameController,
                    ),
                    SizedBox(height: SizeConfig.height * 0.015),
                    CustomTextFormFieldWithTitle(
                      title: tr.contactRelationship,
                      hintText: tr.enterContactRelationship,
                      prefixIcon: CupertinoIcons.reply_all,
                      keyboardType: TextInputType.text,
                      controller: cubit.emergencyRelationshipController,
                    ),
                    SizedBox(height: SizeConfig.height * 0.015),
                    CustomTextFormFieldWithTitle(
                      title: tr.contactNumber,
                      hintText: tr.enterContactNumber,
                      prefixIcon: CupertinoIcons.phone_solid,
                      keyboardType: TextInputType.phone,
                      controller: cubit.emergencyPhoneController,
                      maxLength: 11,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.height * 0.035),

                // ─── Save Button ───
                ElevatedButton(
                  onPressed: isLoading ? null : () => cubit.saveProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.kPrimaryColor.withOpacity(0.6),
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.height * 0.018),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(tr.saveChanges,
                          style: AppTextStyles.title16WhiteBold),
                ),
                SizedBox(height: SizeConfig.height * 0.04),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ══════════════════════════════════════════════
   PROFILE IMAGE PICKER
══════════════════════════════════════════════ */

class _ProfileImagePicker extends StatelessWidget {
  final EditProfileCubit cubit;

  const _ProfileImagePicker({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (_, c) =>
          c is EditProfileImagePicked || c is EditProfileInitial,
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => cubit.pickProfileImage(),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.width * 0.15,
                      backgroundColor: AppColors.kPrimaryColor.withOpacity(0.1),
                      backgroundImage: cubit.pickedImage != null
                          ? FileImage(cubit.pickedImage!) as ImageProvider
                          : NetworkImage(cubit.patient.patient?.image ?? ''),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.01),
              Text(
                tr.tapToChangePhoto,
                style: AppTextStyles.title12Grey,
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ══════════════════════════════════════════════
   SECTION CARD
══════════════════════════════════════════════ */

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.kPrimaryColor, size: 20),
              SizedBox(width: SizeConfig.width * 0.02),
              Text(title, style: AppTextStyles.title16BlackW500),
            ],
          ),
          Divider(
            color: Colors.grey.shade200,
            height: SizeConfig.height * 0.025,
          ),
          ...children,
        ],
      ),
    );
  }
}

/* ══════════════════════════════════════════════
   GENDER SELECTOR
══════════════════════════════════════════════ */

class _GenderSelector extends StatelessWidget {
  final EditProfileCubit cubit;

  const _GenderSelector({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (_, c) =>
          c is EditProfileFieldUpdated || c is EditProfileInitial,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.gender, style: AppTextStyles.title16BlackBold),
            SizedBox(height: SizeConfig.height * 0.01),
            Row(
              children: [
                _GenderCard(
                  label: tr.male,
                  icon: Icons.male,
                  isSelected: cubit.selectedGender == 'Male',
                  onTap: () => cubit.selectGender('Male'),
                ),
                SizedBox(width: SizeConfig.width * 0.03),
                _GenderCard(
                  label: tr.female,
                  icon: Icons.female,
                  isSelected: cubit.selectedGender == 'Female',
                  onTap: () => cubit.selectGender('Female'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.014),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.kPrimaryColor
                : AppColors.kPrimaryColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.kPrimaryColor
                  : AppColors.kPrimaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? Colors.white : AppColors.kPrimaryColor,
                  size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : AppColors.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ══════════════════════════════════════════════
   DATE OF BIRTH PICKER
══════════════════════════════════════════════ */

class _DateOfBirthPicker extends StatelessWidget {
  final EditProfileCubit cubit;

  const _DateOfBirthPicker({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (_, c) =>
          c is EditProfileFieldUpdated || c is EditProfileInitial,
      builder: (context, state) {
        return CustomTextFormFieldWithTitle(
          enableValidator: false,
          title: tr.dateOfBirth,
          hintText: cubit.selectedDateOfBirth?.isEmpty ?? true
              ? tr.selectYourDateOfBirth
              : cubit.selectedDateOfBirth!,
          prefixIcon: CupertinoIcons.calendar,
          keyboardType: TextInputType.datetime,
          enable: false,
          onTap: () => _showDatePicker(context),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final minBirth = DateTime(1900, 1, 1);
    var initial = DateTime(now.year - 20, 6, 15);
    if (initial.isAfter(today)) initial = today;

    BottomPicker.date(
      headerBuilder: (ctx) => Text(
        context.tr.setYourBirthday,
        style: AppTextStyles.title16PrimaryColorW500,
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: initial.isBefore(minBirth) ? minBirth : initial,
      maxDateTime: today,
      minDateTime: minBirth,
      onChange: (_) {},
      onSubmit: (value) {
        cubit.selectDateOfBirth(
          DateFormat().add_yMMMEd().format(DateTime.parse(value.toString())),
        );
      },
      onDismiss: (_) {},
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      buttonSingleColor: AppColors.kPrimaryColor,
    ).show(context);
  }
}

/* ══════════════════════════════════════════════
   BLOOD TYPE DROPDOWN
══════════════════════════════════════════════ */

class _BloodTypeDropdown extends StatelessWidget {
  final EditProfileCubit cubit;

  const _BloodTypeDropdown({required this.cubit});

  static const _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (_, c) =>
          c is EditProfileFieldUpdated || c is EditProfileInitial,
      builder: (context, state) {
        final currentValue = _bloodTypes.contains(cubit.selectedBloodType)
            ? cubit.selectedBloodType
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.bloodType, style: AppTextStyles.title16BlackBold),
            SizedBox(height: SizeConfig.height * 0.006),
            DropdownButtonFormField<String>(
              value: currentValue,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(CupertinoIcons.drop, color: AppColors.kPrimaryColor),
                hintText: tr.enterBloodType,
                hintStyle: AppTextStyles.title14Grey,
                filled: true,
                fillColor: Colors.white10,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.03,
                  vertical: SizeConfig.height * 0.016,
                ),
                border: _buildBorder(),
                enabledBorder: _buildBorder(),
                focusedBorder: _buildBorder(),
              ),
              items: _bloodTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) cubit.selectBloodType(v);
              },
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _buildBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
            color: AppColors.kPrimaryColor, width: 0.5),
      );
}
