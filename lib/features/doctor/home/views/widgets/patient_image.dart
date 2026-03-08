import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class PatientImage extends StatelessWidget {
  const PatientImage({
    super.key,
    required this.patientImage,
  });

  final String patientImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width * 0.22,
      constraints: BoxConstraints(
        minHeight: SizeConfig.height * 0.12,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        image: DecorationImage(
          image: NetworkImage(patientImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
