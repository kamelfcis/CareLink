import 'package:care_link/core/helper/patient_qr_payload.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Premium glass card with mini QR; tap opens fullscreen modal with share.
class PatientIdentityQrCard extends StatelessWidget {
  const PatientIdentityQrCard({
    super.key,
    required this.patientId,
    required this.patientName,
    this.compact = false,
  });

  final String patientId;
  final String patientName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final payload = buildPatientQrPayload(patientId);
    final qrSize = compact ? SizeConfig.width * 0.18 : SizeConfig.width * 0.22;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openFullscreenModal(
          context,
          payload: payload,
          patientName: patientName,
        ),
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.28),
                Colors.white.withOpacity(0.08),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.45),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimaryColor.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.016,
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'patient_qr_$patientId',
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: payload,
                      version: QrVersions.auto,
                      size: qrSize,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF0D3D40),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF007A7F),
                      ),
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.width * 0.035),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: SizeConfig.width * 0.045,
                            color: Colors.white,
                          ),
                          SizedBox(width: SizeConfig.width * 0.02),
                          Expanded(
                            child: Text(
                              tr.patientQrCardTitle,
                              style: AppTextStyles.title16WhiteW600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.height * 0.004),
                      Text(
                        tr.patientQrCardSubtitle,
                        style: AppTextStyles.title12White70,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: SizeConfig.height * 0.008),
                      Row(
                        children: [
                          Text(
                            tr.patientQrExpandHint,
                            style: AppTextStyles.title12White70.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.open_in_full_rounded,
                            size: 14,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openFullscreenModal(
  BuildContext context, {
  required String payload,
  required String patientName,
}) async {
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.65),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return _PatientQrFullscreenPage(
        payload: payload,
        patientName: patientName,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
      );
    },
  );
}

class _PatientQrFullscreenPage extends StatelessWidget {
  const _PatientQrFullscreenPage({
    required this.payload,
    required this.patientName,
  });

  final String payload;
  final String patientName;

  Future<void> _share(BuildContext context) async {
    final tr = context.tr;
    await Share.share(
      payload,
      subject: '${tr.patientQrCardTitle} — $patientName',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final size = MediaQuery.sizeOf(context);
    final qrDimension = (size.shortestSide * 0.72).clamp(220.0, 340.0);

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.06,
              vertical: SizeConfig.height * 0.02,
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.94),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0A4A4E),
                    AppColors.kPrimaryDark,
                    AppColors.kPrimaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimaryColor.withOpacity(0.35),
                    blurRadius: 40,
                    spreadRadius: 2,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      8,
                      8,
                      8,
                      0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.close_rounded, size: 26),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _share(context),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.ios_share_rounded, size: 24),
                          tooltip: tr.patientQrShare,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 0.06,
                    ),
                    child: Text(
                      patientName,
                      style: AppTextStyles.title20WhiteBold,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.008),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 0.08,
                    ),
                    child: Text(
                      tr.patientQrModalDescription,
                      style: AppTextStyles.title14White70,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.028),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: InteractiveViewer(
                      minScale: 0.85,
                      maxScale: 4,
                      child: QrImageView(
                        data: payload,
                        version: QrVersions.auto,
                        size: qrDimension,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF0D3D40),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF007A7F),
                        ),
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.024),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      SizeConfig.width * 0.06,
                      0,
                      SizeConfig.width * 0.06,
                      SizeConfig.height * 0.028,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _share(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.kPrimaryDark,
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.height * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.share_rounded, size: 22),
                        label: Text(
                          tr.patientQrShare,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
