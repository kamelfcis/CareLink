import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';

import 'package:flutter/material.dart';

class OrSignWith extends StatelessWidget {
  const OrSignWith({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.height * 0.015,
        horizontal: SizeConfig.width * 0.02,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.black26,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.02,
            ),
            child: Text(
              context.tr.orSignInWith,
              style: AppTextStyles.title14Grey,
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.black26,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
