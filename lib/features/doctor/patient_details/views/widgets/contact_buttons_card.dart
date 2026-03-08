import 'package:care_link/core/constants/app_constants.dart';
import 'package:care_link/core/helper/launch_link.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/contact_button.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/qr_dialog.dart';
import 'package:flutter/material.dart';

class ContactButtonsRow extends StatelessWidget {
  final PatientModel patient;

  const ContactButtonsRow({super.key, required this.patient});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.04,
          vertical: SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          ContactButton(
            icon: Icons.phone,
            label: context.tr.mobile,
            onTap: () {
              launchUrlSocialMedia(
                url: "tel:${patient.patient!.phone}",
              );
            },
          ),
          ContactButton(
            icon: Icons.chat_bubble_outline,
            label: context.tr.whatsApp,
            onTap: () {
              final whatsappUrl = "https://wa.me/${patient.patient!.phone}";
              launchUrlSocialMedia(url: whatsappUrl);
            },
          ),
          ContactButton(
            icon: Icons.qr_code,
            label: context.tr.qrCode,
            onTap: () {
              _showQRDialog(context, AppConstants.qrCodeUrl);
            },
          ),
        ],
      ),
    );
  }

  void _showQRDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRDialog();
      },
    );
  }
}

