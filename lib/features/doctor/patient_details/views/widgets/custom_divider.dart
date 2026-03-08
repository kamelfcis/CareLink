import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.shade300,
      height: SizeConfig.height * 0.02,
    );
  }
}
