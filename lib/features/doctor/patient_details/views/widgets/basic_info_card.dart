import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/custom_divider.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/info_row.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/white_card.dart';
import 'package:flutter/material.dart';

class BasicInfoCard extends StatelessWidget {
  final PatientModel patient;

  const BasicInfoCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        children: [
          InfoRow(label: context.tr.gender, value: patient.gender),
          CustomDivider(),
          InfoRow(label: context.tr.dateOfBirth, value: patient.dateOfBirth),
          CustomDivider(),
          InfoRow(label: context.tr.bloodType, value: patient.bloodType),
          CustomDivider(),
          InfoRow(label: context.tr.weight, value: context.tr.weightKg(patient.weight.toString())),
          CustomDivider(),
          InfoRow(label: context.tr.height, value: context.tr.heightCm(patient.height.toString())),
        ],
      ),
    );
  }
}
