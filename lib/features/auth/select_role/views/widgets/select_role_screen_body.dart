import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/components/custom_elevated_button.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/select_role/views/widgets/role_card.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:care_link/features/auth/sign_in/views/widgets/app_logo.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectRoleScreenBody extends StatelessWidget {
  const SelectRoleScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final ValueNotifier<UserRole?> selectedRole =
        ValueNotifier<UserRole?>(null);
    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.05,
          vertical: SizeConfig.height * 0.025,
        ),
        child: Column(
          children: [
            const Spacer(),
            AppLogo(),
            Spacer(flex: 4),
            ValueListenableBuilder<UserRole?>(
              valueListenable: selectedRole,
              builder: (context, role, _) {
                return Column(
                  children: [
                    RoleCard(
                      icon: FontAwesomeIcons.userInjured,
                      subtitle: tr.findDesiredDoctor,
                      title: tr.asAPatient,
                      isSelected: role == UserRole.patient,
                      onTap: () => selectedRole.value = UserRole.patient,
                    ),
                    SizedBox(height: SizeConfig.height * 0.02),
                    RoleCard(
                      icon: FontAwesomeIcons.userDoctor,
                      subtitle: tr.joinAsHealthcareProvider,
                      title: tr.asADoctor,
                      isSelected: role == UserRole.doctor,
                      onTap: () => selectedRole.value = UserRole.doctor,
                    ),
                  ],
                );
              },
            ),
            Spacer(flex: 4),
            ValueListenableBuilder<UserRole?>(
              valueListenable: selectedRole,
              builder: (context, role, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: selectedRole.value != null
                      ? Padding(
                          padding:
                              EdgeInsets.only(bottom: SizeConfig.height * 0.03),
                          child: CustomElevatedButton(
                            key: const ValueKey("continue_button"),
                            name: tr.continueBtn,
                            onPressed: () {
                              if (selectedRole.value!.name == UserRole.patient.name) {
                                context.pushReplacementScreen(
                                    RouteNames.signUpAsPatientScreen);
                              } else {
                                context.pushReplacementScreen(
                                    RouteNames.signUpAsDoctorScreen);
                              }
                            },
                            hPadding: SizeConfig.height * 0.02,
                            width: double.infinity,
                          ),
                        )
                      : SizedBox(height: SizeConfig.height * 0.05),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
