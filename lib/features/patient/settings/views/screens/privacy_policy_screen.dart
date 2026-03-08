import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kPrimaryColor.withOpacity(0.7),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(SizeConfig.width * 0.04),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(SizeConfig.width * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: SizeConfig.width * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.width * 0.03),
                    Icon(Icons.privacy_tip_rounded,
                        color: Colors.white, size: SizeConfig.width * 0.065),
                    SizedBox(width: SizeConfig.width * 0.025),
                    Text(
                      tr.privacyPolicyTitle,
                      style: AppTextStyles.title22WhiteColorBold,
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(SizeConfig.width * 0.05),
                      children: [
                        // Last updated
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width * 0.04,
                            vertical: SizeConfig.height * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.update_rounded,
                                  color: AppColors.kPrimaryColor, size: 18),
                              SizedBox(width: 8),
                              Text(
                                tr.privacyPolicyLastUpdated,
                                style: TextStyle(
                                  color: AppColors.kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.height * 0.025),
                        // Intro
                        Text(
                          tr.privacyPolicyIntro,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: SizeConfig.height * 0.025),
                        // Sections
                        _PolicySection(
                          icon: Icons.folder_shared_outlined,
                          title: tr.privacyInfoCollectTitle,
                          description: tr.privacyInfoCollectDesc,
                        ),
                        _PolicySection(
                          icon: Icons.analytics_outlined,
                          title: tr.privacyHowWeUseTitle,
                          description: tr.privacyHowWeUseDesc,
                        ),
                        _PolicySection(
                          icon: Icons.shield_outlined,
                          title: tr.privacyDataSecurityTitle,
                          description: tr.privacyDataSecurityDesc,
                        ),
                        _PolicySection(
                          icon: Icons.share_outlined,
                          title: tr.privacySharingTitle,
                          description: tr.privacySharingDesc,
                        ),
                        _PolicySection(
                          icon: Icons.gavel_outlined,
                          title: tr.privacyRightsTitle,
                          description: tr.privacyRightsDesc,
                        ),
                        _PolicySection(
                          icon: Icons.email_outlined,
                          title: tr.privacyContactTitle,
                          description: tr.privacyContactDesc,
                        ),
                        SizedBox(height: SizeConfig.height * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PolicySection({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.height * 0.022),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.kPrimaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.width * 0.01),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}








