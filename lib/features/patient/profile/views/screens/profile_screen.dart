import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientProfileScreen extends StatelessWidget {
  final PatientModel patient;

  const PatientProfileScreen({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GradientHeader(
        child: ListView(
          padding: EdgeInsets.all(SizeConfig.width * 0.04),
          children: [
            _Header(patient: patient),
            SizedBox(height: SizeConfig.height * 0.02),
            _BasicInfoCard(patient: patient),
            SizedBox(height: SizeConfig.height * 0.02),
            _EmergencyContactCard(patient: patient),
            SizedBox(height: SizeConfig.height * 0.025),
            _SectionTitle(title: context.tr.medicalRecords),
            SizedBox(height: SizeConfig.height * 0.012),
            _MedicalGrid(),
          ],
        ),
      ),
    );
  }
}

/* ===================== HEADER ===================== */

class _Header extends StatelessWidget {
  final PatientModel patient;

  const _Header({required this.patient});

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
          CircleAvatar(
            radius: SizeConfig.width * 0.1,
            backgroundImage: NetworkImage(patient.patient!.image),
          ),
          SizedBox(width: SizeConfig.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.patient!.name,
                  style: AppTextStyles.title18WhiteW500,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  patient.patient!.email,
                  style: AppTextStyles.title12White70,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== BASIC INFO ===================== */

class _BasicInfoCard extends StatelessWidget {
  final PatientModel patient;

  const _BasicInfoCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _InfoRow(context.tr.gender, patient.gender),
          _Divider(),
          _InfoRow(context.tr.dateOfBirth, patient.dateOfBirth),
          _Divider(),
          _InfoRow(context.tr.bloodType, patient.bloodType),
          _Divider(),
          _InfoRow(context.tr.weight, context.tr.weightKg(patient.weight.toString())),
          _Divider(),
          _InfoRow(context.tr.height, context.tr.heightCm(patient.height.toString())),
        ],
      ),
    );
  }
}

/* ===================== EMERGENCY ===================== */

class _EmergencyContactCard extends StatelessWidget {
  final PatientModel patient;

  const _EmergencyContactCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final contact = patient.emergencyContact;

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.emergencyContact, style: AppTextStyles.title16BlackW500),
          SizedBox(height: 10),
          _InfoRow(context.tr.name, contact.name),
          _Divider(),
          _InfoRow(context.tr.relationship, contact.relationship),
          _Divider(),
          _InfoRow(context.tr.phone, contact.phone),
        ],
      ),
    );
  }
}

/* ===================== MEDICAL GRID ===================== */

class _MedicalGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patientId = getIt<CacheHelper>().getPatientModel()!.id;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: SizeConfig.height * 0.015,
      crossAxisSpacing: SizeConfig.width * 0.03,
      childAspectRatio: 1.2,
      children: [
        _MedicalItem(
          title: context.tr.chronicDiseases,
          icon: Icons.monitor_heart_outlined,
          onTap: () {
            context.pushScreen(RouteNames.chronicConditionsScreen,
                arguments: patientId);
          },
        ),
        _MedicalItem(
          title: context.tr.medications,
          icon: Icons.medication_outlined,
          onTap: () {
            context.pushScreen(RouteNames.medicationsScreen,
                arguments: patientId);
          },
        ),
        _MedicalItem(
          title: context.tr.allergies,
          icon: Icons.warning_amber_outlined,
          onTap: () {
            context.pushScreen(RouteNames.allergiesScreen,
                arguments: patientId);
          },
        ),
        _MedicalItem(
          title: context.tr.vaccinations,
          icon: Icons.vaccines_outlined,
          onTap: () {
            context.pushScreen(RouteNames.vaccinationsScreen,
                arguments: patientId);
          },
        ),
        _MedicalItem(
          title: context.tr.surgeries,
          icon: Icons.local_hospital_outlined,
          onTap: () {
            context.pushScreen(RouteNames.surgeriesScreen,
                arguments: patientId);
          },
        ),
        _MedicalItem(
          title: context.tr.labTests,
          icon: Icons.science_outlined,
          onTap: () {
            context.pushScreen(RouteNames.labTestsScreen,
                arguments: patientId);
          },
        ),
      ],
    );
  }
}

class _MedicalItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const _MedicalItem({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: SizeConfig.width * 0.08, color: AppColors.kPrimaryColor),
            SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.title12BlackColorW400,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== SHARED ===================== */

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

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
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.title14Grey),
        ),
        Text(value, style: AppTextStyles.title14Black),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.shade300,
      height: SizeConfig.height * 0.02,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.title18WhiteW500,
    );
  }
}
