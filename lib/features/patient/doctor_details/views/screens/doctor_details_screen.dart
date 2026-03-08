import 'package:care_link/core/helper/launch_link.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/patient/doctor_details/view_models/cubit/connect_with_doctor_cubit.dart';
import 'package:care_link/features/patient/doctor_details/views/widgets/connect_button.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final doctor = DoctorModel.fromJson(args);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DoctorProfileScreenBody(doctor: doctor),
    );
  }
}

class DoctorProfileScreenBody extends StatelessWidget {
  const DoctorProfileScreenBody({
    super.key,
    required this.doctor,
  });

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectWithDoctorCubit, ConnectWithDoctorState>(
      listener: (context, state) {
        if (state is ConnectWithDoctorSuccess) {
          context.popScreen();
          CustomQuickAlert.success(
            title: context.tr.success,
            message: context.tr.connectedWithDoctorSuccess,
          );
        }
        if (state is ConnectWithDoctorFailure) {
          CustomQuickAlert.error(
            title: context.tr.error,
            message: state.message,
          );
        }
      },
      child: GradientHeader(
        child: ListView(
          padding: EdgeInsets.all(SizeConfig.width * 0.04),
          children: [
            _DoctorHeader(doctor: doctor),
            SizedBox(height: SizeConfig.height * 0.02),
            _DoctorDetailsCard(doctor: doctor),
            SizedBox(height: SizeConfig.height * 0.02),
            _ContactSection(
              doctor: doctor,
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            ConnectButton(doctorId: doctor.id),
          ],
        ),
      ),
    );
  }
}

class _DoctorHeader extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorHeader({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: SizeConfig.width * 0.1,
              backgroundImage: NetworkImage(doctor.doctor!.image),
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.doctor!.name,
                  style: AppTextStyles.title18WhiteW500,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  doctor.specialty.name,
                  style: AppTextStyles.title12White70,
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: Colors.white70,
                        size: SizeConfig.width * 0.04),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doctor.hospital,
                        style: AppTextStyles.title12WhiteW500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== DETAILS CARD ===================== */

class _DoctorDetailsCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorDetailsCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          _InfoRow(
            title: context.tr.email,
            value: doctor.doctor!.email,
            icon: Icons.email_outlined,
          ),
          _Divider(),
          _InfoRow(
            title: context.tr.phone,
            value: doctor.doctor!.phone,
            icon: Icons.phone_outlined,
          ),
          _Divider(),
          _InfoRow(
            title: context.tr.specialty,
            value: doctor.specialty.name,
            icon: Icons.medical_services_outlined,
          ),
          _Divider(),
          _InfoRow(
            title: context.tr.aboutDoctor,
            value: doctor.bio,
            icon: Icons.info_outline,
            isMultiline: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isMultiline;

  const _InfoRow({
    required this.title,
    required this.value,
    required this.icon,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.01),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon,
              color: AppColors.kPrimaryColor,
              size: SizeConfig.width * 0.055),
          SizedBox(width: SizeConfig.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title12Grey),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.title14Black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.shade300,
      height: SizeConfig.height * 0.015,
    );
  }
}

/* ===================== CONTACT ===================== */

class _ContactSection extends StatelessWidget {
  final DoctorModel doctor;

  const _ContactSection({required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ContactButton(
          icon: Icons.phone,
          label: context.tr.call,
          onTap: () {
            launchUrlSocialMedia(url: "tel:${doctor.doctor!.phone}");
          },
        ),
        _ContactButton(
          icon: FontAwesomeIcons.whatsapp,
          label: context.tr.whatsApp,
          onTap: () {
            launchUrlSocialMedia(url: "https://wa.me/${doctor.doctor!.phone}");
          },
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ContactButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.015),
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: AppColors.kPrimaryColor,
                  size: SizeConfig.width * 0.055),
              SizedBox(height: 6),
              Text(label, style: AppTextStyles.title12BlackColorW400),
            ],
          ),
        ),
      ),
    );
  }
}
