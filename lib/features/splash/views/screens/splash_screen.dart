import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/features/splash/views/widgets/splash_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateToNextScreen();
    super.initState();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      final supabase = getIt<SupabaseClient>();
      final cacheHelper = getIt<CacheHelper>();
      if (supabase.auth.currentUser != null &&
          cacheHelper.getDoctorModel() != null) {
        context.pushReplacementScreen(RouteNames.doctorHomeScreen);
      } else if (supabase.auth.currentUser != null &&
          cacheHelper.getPatientModel() != null) {
        context.pushReplacementScreen(RouteNames.patientHomeScreen);
      } else {
        context.pushReplacementScreen(RouteNames.onBoardingScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenBody(),
    );
  }
}
