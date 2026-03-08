import 'package:care_link/core/components/custom_text_form_field.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            hintText: context.tr.searchForPatient,
            prefixIcon: Icons.search,
            enable: false,
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.02),
        Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.filter_list,
            color: Colors.white,
            size: SizeConfig.width * 0.06,
          ),
        ),
      ],
    );
  }
}
