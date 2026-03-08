import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/basic_info_card.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/contact_buttons_card.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/emergency_contact_card.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/header.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/medical_grid.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/section_title.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:flutter/material.dart';

class PatientProfileScreenBody extends StatelessWidget {
  const PatientProfileScreenBody({
    super.key,
    required this.patient,
  });

  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      child: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.04,
            vertical: SizeConfig.height * 0.02),
        children: [
          Header(patient: patient),
          SizedBox(height: SizeConfig.height * 0.025),
          ContactButtonsRow(
            patient: patient,
          ),
          SizedBox(height: SizeConfig.height * 0.025),
          BasicInfoCard(patient: patient),
          SizedBox(height: SizeConfig.height * 0.025),
          EmergencyContactCard(contact: patient.emergencyContact),
          SizedBox(height: SizeConfig.height * 0.03),
          SectionTitle(title: context.tr.medicalRecords),
          SizedBox(height: SizeConfig.height * 0.015),
          MedicalGrid(
            patientId: patient.id,
          ),
        ],
      ),
    );
  }
}
