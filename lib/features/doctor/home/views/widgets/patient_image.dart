import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class PatientImage extends StatelessWidget {
  const PatientImage({
    super.key,
    this.patientImage,
  });

  final String? patientImage;

  @override
  Widget build(BuildContext context) {
    final imageUrl = patientImage?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

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
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
        color: hasImage ? null : Colors.grey.shade200,
      ),
      child: hasImage
          ? null
          : const Icon(Icons.person_rounded, color: Colors.grey),
    );
  }
}
