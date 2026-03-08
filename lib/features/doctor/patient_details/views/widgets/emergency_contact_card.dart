import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/emergency_contact_model.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/custom_divider.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/info_row.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/white_card.dart';
import 'package:flutter/material.dart';

class EmergencyContactCard extends StatelessWidget {
  final EmergencyContactModel contact;

  const EmergencyContactCard({
    super.key,
    required this.contact,
  });
  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.emergencyContact, style: AppTextStyles.title16BlackW500),
          SizedBox(height: SizeConfig.height * 0.02),
          InfoRow(label: context.tr.name, value: contact.name),
          CustomDivider(),
          InfoRow(label: context.tr.relationship, value: contact.relationship),
          CustomDivider(),
          InfoRow(label: context.tr.phone, value: contact.phone),
        ],
      ),
    );
  }
}
