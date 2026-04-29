import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final PatientModel patient;

  const Header({required this.patient});

  @override
  Widget build(BuildContext context) {
    final patientUser = patient.patient;
    final imageUrl = patientUser?.image.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final patientName = patientUser?.name;
    final patientEmail = patientUser?.email;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.04,
          vertical: SizeConfig.height * 0.015),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.width * 0.1,
            backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
            child: hasImage
                ? null
                : const Icon(Icons.person_rounded, color: Colors.grey),
          ),
          SizedBox(width: SizeConfig.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName != null && patientName.isNotEmpty
                      ? patientName
                      : 'Unknown patient',
                  style: AppTextStyles.title18WhiteW500,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  patientEmail != null && patientEmail.isNotEmpty
                      ? patientEmail
                      : 'No email',
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
