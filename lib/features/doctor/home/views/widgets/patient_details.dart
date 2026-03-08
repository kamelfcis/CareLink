import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/doctor/home/views/widgets/patient_rating.dart';
import 'package:flutter/material.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({
    super.key,
    required this.patient,
  });

  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.04,
            vertical: SizeConfig.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              patient.patient!.name,
              style: AppTextStyles.title18BlackW600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: SizeConfig.height * 0.005),
            Row(
              children: [
                Icon(Icons.cake,
                    size: SizeConfig.width * 0.04, color: Colors.grey[600]),
                SizedBox(width: SizeConfig.width * 0.01),
                Text(
                  patient.dateOfBirth,
                  style: AppTextStyles.title12Grey,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.01),
            PatientRating(),
          ],
        ),
      ),
    );
  }
}

