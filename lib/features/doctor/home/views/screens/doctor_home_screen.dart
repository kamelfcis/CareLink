import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/doctor/home/views/widgets/doctor_home_screen_body.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoctorHomeScreenBody(),
      floatingActionButton: _ChatBotFab(),
    );
  }
}

class _ChatBotFab extends StatefulWidget {
  @override
  State<_ChatBotFab> createState() => _ChatBotFabState();
}

class _ChatBotFabState extends State<_ChatBotFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.chatBotScreen);
          },
          child: Icon(
            Icons.auto_awesome,
            size: SizeConfig.width * 0.065,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
