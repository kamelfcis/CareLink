import 'package:flutter/material.dart';
import 'package:care_link/features/auth/sign_up_as_patient/views/widgets/sign_up_as_patient_screen_body.dart';

class SignUpAsPatientScreen extends StatelessWidget {
  const SignUpAsPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpAsPatientScreenBody(),
    );
  }
}
