import 'package:care_link/core/constants/app_constants.dart';
import 'package:care_link/core/helper/launch_link.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDialog extends StatelessWidget {
  const QRDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.04,
          vertical: SizeConfig.height * 0.02,
        ),
        constraints: BoxConstraints(
          maxWidth: SizeConfig.width * 0.8,
          maxHeight: SizeConfig.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("QR Code", style: AppTextStyles.title20BlackBold),
            SizedBox(height: SizeConfig.height * 0.005),
            Text("Scan this QR code to visit the site."),
            SizedBox(height: SizeConfig.height * 0.03),
            SizedBox(
              width: SizeConfig.width * 0.4,
              height: SizeConfig.width * 0.4,
              child: QrImageView(
                data: AppConstants.qrCodeUrl,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.popScreen();
                  launchUrlSocialMedia(url: AppConstants.qrCodeUrl);
                },
                icon:
                    const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: const Text("Scan / Open"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.kPrimaryColor,
              ),
              onPressed: (){
                context.popScreen();
              },
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
