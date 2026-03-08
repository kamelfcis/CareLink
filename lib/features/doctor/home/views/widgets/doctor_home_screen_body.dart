import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/doctor/home/views/widgets/doctor_home_screen_header.dart';
import 'package:care_link/features/doctor/home/views/widgets/patient_list_view.dart';
import 'package:care_link/features/doctor/home/views/widgets/search_and_filter.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreenBody extends StatelessWidget {
  const DoctorHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.03,
          vertical: SizeConfig.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorHomeScreenHeader(),
            SizedBox(height: SizeConfig.height * 0.012),
            SearchAndFilter(),
            SizedBox(height: SizeConfig.height * 0.02),
            PatientsListView(),
          ],
        ),
      ),
    );
  }
}



