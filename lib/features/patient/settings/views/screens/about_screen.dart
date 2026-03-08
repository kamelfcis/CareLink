import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                    Icon(Icons.info_outline_rounded,
                        color: Colors.white, size: SizeConfig.width * 0.065),
                    SizedBox(width: SizeConfig.width * 0.025),
                    Text(
                      tr.aboutTitle,
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
                    borderRadius: const BorderRadius.vertical(
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
                        // App Logo + Version
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.all(SizeConfig.width * 0.05),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.kPrimaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.kPrimaryColor,
                                  size: SizeConfig.width * 0.12,
                                ),
                              ),
                              SizedBox(height: SizeConfig.height * 0.015),
                              Text(
                                'CareLink',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.kPrimaryColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.kPrimaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tr.aboutVersion('1.0.0'),
                                  style: TextStyle(
                                    color: AppColors.kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.height * 0.025),
                        // Description
                        Text(
                          tr.aboutDesc,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.height * 0.03),
                        // Mission
                        _AboutCard(
                          icon: Icons.flag_rounded,
                          title: tr.aboutMission,
                          description: tr.aboutMissionDesc,
                        ),
                        SizedBox(height: SizeConfig.height * 0.02),
                        // Features
                        _AboutCard(
                          icon: Icons.star_rounded,
                          title: tr.aboutFeatures,
                          child: Column(
                            children: [
                              _FeatureRow(
                                  icon: Icons.people_alt_outlined,
                                  text: tr.aboutFeature1),
                              _FeatureRow(
                                  icon: Icons.medical_information_outlined,
                                  text: tr.aboutFeature2),
                              _FeatureRow(
                                  icon: Icons.auto_awesome,
                                  text: tr.aboutFeature3),
                              _FeatureRow(
                                  icon: Icons.monitor_heart_outlined,
                                  text: tr.aboutFeature4),
                              _FeatureRow(
                                  icon: Icons.lock_outline_rounded,
                                  text: tr.aboutFeature5),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.height * 0.03),
                        // Team
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.all(SizeConfig.width * 0.03),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.kPrimaryColor.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.code_rounded,
                                  color: AppColors.kPrimaryColor,
                                  size: 24,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                tr.aboutTeam,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                tr.aboutTeamDesc,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: SizeConfig.height * 0.015),
                              Text(
                                tr.aboutPoweredBy,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? child;

  const _AboutCard({
    required this.icon,
    required this.title,
    this.description,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.kPrimaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.012),
          if (description != null)
            Text(
              description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.006),
      child: Row(
        children: [
          Icon(icon, color: AppColors.kPrimaryColor, size: 20),
          SizedBox(width: SizeConfig.width * 0.03),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}








