import 'package:care_link/core/helper/launch_link.dart';
import 'package:care_link/core/helper/patient_qr_payload.dart';
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
    final phone = patient.patient?.phone.trim() ?? '';
    final whatsappPhone = _normalizeEgyptPhoneForWhatsApp(phone);
    final canCall = phone.isNotEmpty;
    final canWhatsApp = whatsappPhone.isNotEmpty;
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
            onTap: canCall
                ? () {
                    launchUrlSocialMedia(
                      url: "tel:$phone",
                    );
                  }
                : null,
          ),
          ContactButton(
            icon: Icons.chat_bubble_outline,
            label: context.tr.whatsApp,
            onTap: canWhatsApp
                ? () {
                    final whatsappUrl = "https://wa.me/$whatsappPhone";
                    launchUrlSocialMedia(url: whatsappUrl);
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Patient phone number is unavailable for WhatsApp.'),
                      ),
                    );
                  },
          ),
          ContactButton(
            icon: Icons.qr_code,
            label: context.tr.qrCode,
            onTap: () {
              _showQRDialog(context, buildPatientQrPayload(patient.id));
            },
          ),
        ],
      ),
    );
  }

  void _showQRDialog(BuildContext context, String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRDialog(qrData: qrData);
      },
    );
  }

  /// WhatsApp requires international digits-only format.
  /// Example Egypt local `01xxxxxxxxx` -> `201xxxxxxxxx`.
  String _normalizeEgyptPhoneForWhatsApp(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digitsOnly.isEmpty) return '';

    String normalized = digitsOnly;
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    }
    if (normalized.startsWith('0')) {
      normalized = '20${normalized.substring(1)}';
    } else if (!normalized.startsWith('20')) {
      // Fallback for local values without country code.
      normalized = '20$normalized';
    }
    return normalized;
  }
}

