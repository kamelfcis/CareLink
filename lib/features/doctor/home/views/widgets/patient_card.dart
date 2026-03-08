import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/doctor/home/views/widgets/patient_details.dart';
import 'package:care_link/features/doctor/home/views/widgets/patient_image.dart';
import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patient});
  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.height * 0.12,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.02,
        vertical: SizeConfig.height * 0.008,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            PatientImage(patientImage: patient.patient!.image),
            PatientDetails(patient: patient),
          ],
        ),
      ),
    );
  }
}
