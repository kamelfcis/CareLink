import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/medical_item.dart';
import 'package:flutter/material.dart';

class MedicalGrid extends StatelessWidget {
  final String patientId;

  const MedicalGrid({required this.patientId});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: SizeConfig.height * 0.02,
      crossAxisSpacing: SizeConfig.width * 0.02,
      childAspectRatio: 1.1,
      children: [
        MedicalItem(
          title: context.tr.chronicDiseases,
          icon: Icons.monitor_heart_outlined,
          onTap: () {
            context.pushScreen(RouteNames.chronicConditionsScreen,
                arguments: patientId);
          },
        ),
        MedicalItem(
          title: context.tr.medications,
          icon: Icons.medication_outlined,
          onTap: () {
            context.pushScreen(RouteNames.medicationsScreen,
                arguments: patientId);
          },
        ),
        MedicalItem(
          title: context.tr.allergies,
          icon: Icons.warning_amber_outlined,
          onTap: () {
            context.pushScreen(RouteNames.allergiesScreen,
                arguments: patientId);
          },
        ),
        MedicalItem(
          title: context.tr.vaccinations,
          icon: Icons.vaccines_outlined,
          onTap: () {
            context.pushScreen(RouteNames.vaccinationsScreen,
                arguments: patientId);
          },
        ),
        MedicalItem(
          title: context.tr.surgeries,
          icon: Icons.local_hospital_outlined,
          onTap: () {
            context.pushScreen(RouteNames.surgeriesScreen,
                arguments: patientId);
          },
        ),
        MedicalItem(
          title: context.tr.labTests,
          icon: Icons.science_outlined,
          onTap: () {
            context.pushScreen(RouteNames.labTestsScreen, arguments: patientId);
          },
        ),
      ],
    );
  }
}
