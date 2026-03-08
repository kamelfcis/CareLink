import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/locale/locale_cubit.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/forgot_password/views/screens/forgot_password_screen.dart';
import 'package:care_link/features/patient/my_doctors/views/screens/my_doctors_screen.dart';
import 'package:care_link/features/patient/profile/views/screens/profile_screen.dart';
import 'package:care_link/features/patient/settings/views/screens/about_screen.dart';
import 'package:care_link/features/patient/settings/views/screens/privacy_policy_screen.dart';
import 'package:care_link/features/patient/settings/views/widgets/rate_us_dialog.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          child: ListView(
            padding: EdgeInsets.all(SizeConfig.width * 0.04),
            children: [
              _Header(),
              SizedBox(height: SizeConfig.height * 0.025),
              _SectionTitle(title: tr.account),
              _SettingsTile(
                icon: Icons.person_outline,
                title: tr.profile,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PatientProfileScreen(
                        patient: getIt<CacheHelper>().getPatientModel()!,
                      );
                    },
                  ));
                },
              ),
              _SettingsTile(
                icon: Icons.favorite_border,
                title: tr.myDoctors,
                subtitle: tr.doctorsConnectedWith,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyDoctorsScreen(),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: tr.changePassword,
                subtitle: tr.changePasswordDesc,
                onTap: () {
                  final email = getIt<CacheHelper>()
                          .getPatientModel()
                          ?.patient
                          ?.email ??
                      '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ForgotPasswordScreen(initialEmail: email),
                    ),
                  );
                },
              ),
              SizedBox(height: SizeConfig.height * 0.02),
              _SectionTitle(title: tr.app),
              _LanguageTile(),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: tr.privacyPolicy,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.star_rate_outlined,
                title: tr.rateUs,
                onTap: () => showRateUsDialog(context),
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: tr.about,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: SizeConfig.height * 0.02),
              _SectionTitle(title: tr.support),
              _SettingsTile(
                icon: Icons.contact_support_outlined,
                title: tr.contactUs,
                subtitle: tr.contactUsDesc,
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.chatBotScreen);
                },
              ),
              SizedBox(height: SizeConfig.height * 0.03),
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== HEADER ===================== */

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.settings,
            color: Colors.white, size: SizeConfig.width * 0.065),
        SizedBox(width: SizeConfig.width * 0.025),
        Text(
          context.tr.settings,
          style: AppTextStyles.title22WhiteColorBold,
        ),
      ],
    );
  }
}

/* ===================== SECTION TITLE ===================== */

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.height * 0.012,
      ),
      child: Text(
        title,
        style: AppTextStyles.title16BlackW500,
      ),
    );
  }
}

/* ===================== LANGUAGE TOGGLE TILE ===================== */

class _LanguageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.read<LocaleCubit>().toggleLocale(),
          child: Container(
            margin: EdgeInsets.only(bottom: SizeConfig.height * 0.01),
            padding: EdgeInsets.all(SizeConfig.width * 0.035),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.width * 0.025),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language,
                    color: AppColors.kPrimaryColor,
                    size: SizeConfig.width * 0.055,
                  ),
                ),
                SizedBox(width: SizeConfig.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr.language, style: AppTextStyles.title14Black),
                      SizedBox(height: 2),
                      Text(
                        isArabic ? tr.arabic : tr.english,
                        style: AppTextStyles.title12Grey,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width * 0.03,
                    vertical: SizeConfig.height * 0.006,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? tr.arabicShort : tr.englishShort,
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.width * 0.032,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.swap_horiz,
                        color: AppColors.kPrimaryColor,
                        size: SizeConfig.width * 0.04,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ===================== TILE ===================== */

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.height * 0.01),
        padding: EdgeInsets.all(SizeConfig.width * 0.035),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.025),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.kPrimaryColor,
                size: SizeConfig.width * 0.055,
              ),
            ),
            SizedBox(width: SizeConfig.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title14Black),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(subtitle!, style: AppTextStyles.title12Grey),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: SizeConfig.width * 0.04, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/* ===================== LOGOUT ===================== */

class _LogoutButton extends StatefulWidget {
  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _isLoading = false;

  Future<void> _handleLogout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimaryColor),
          ),
        );
      },
    );

    try {
      await Supabase.instance.client.auth.signOut();
      await getIt<CacheHelper>().clearData();
      final cacheHelper = getIt<CacheHelper>();
      cacheHelper.clearData();
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
      }
      if (mounted) {
        context.pushAndRemoveUntilScreen(RouteNames.signInScreen);
        CustomQuickAlert.success(
          title: context.tr.success,
          message: context.tr.loggedOutSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr.errorLoggingOut(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _isLoading ? null : () => _handleLogout(context),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.width * 0.035),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              SizedBox(
                width: SizeConfig.width * 0.05,
                height: SizeConfig.width * 0.05,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            else ...[
              Icon(Icons.logout,
                  color: Colors.red, size: SizeConfig.width * 0.055),
              SizedBox(width: SizeConfig.width * 0.02),
            ],
            Text(
              _isLoading ? tr.loggingOut : tr.logOut,
              style: AppTextStyles.title16Black.copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
