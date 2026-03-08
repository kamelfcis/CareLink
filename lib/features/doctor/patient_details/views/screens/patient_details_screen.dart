import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:care_link/features/doctor/patient_details/views/widgets/patient_profile_screen_body.dart';
import 'package:flutter/material.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patient = PatientModel.fromJson(args);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PatientProfileScreenBody(patient: patient),
    );
  }
}
