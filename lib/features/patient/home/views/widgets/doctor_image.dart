import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class DoctorImage extends StatelessWidget {
  const DoctorImage({
    super.key,
    required this.doctorImage,
  });

  final String doctorImage;

  @override
  Widget build(BuildContext context) {
    final radius = SizeConfig.width * 0.09;
    return Positioned(
      top: 0,
      left: SizeConfig.width * 0.04,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: radius - 3,
          backgroundImage: NetworkImage(doctorImage),
        ),
      ),
    );
  }
}
