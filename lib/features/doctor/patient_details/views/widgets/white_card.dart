import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class WhiteCard extends StatelessWidget {
  final Widget child;

  const WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.05,
          vertical: SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
