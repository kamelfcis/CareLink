import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/view_models/cubit/sign_up_as_patient_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_patient/views/widgets/gender_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectPatientGender extends StatelessWidget {
  const SelectPatientGender({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignUpAsPatientCubit>();
    final tr = context.tr;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.gender, style: AppTextStyles.title18BlackBold),
        SizedBox(height: SizeConfig.height * 0.01),
        BlocBuilder<SignUpAsPatientCubit, SignUpAsPatientState>(
          buildWhen: (previous, current) => current is UpdateGender,
          builder: (context, state) {
            return Row(
              children: [
                GenderCard(
                  key: const Key("male"),
                  genderName: tr.male,
                  genderIcon: FontAwesomeIcons.male,
                  isSelected: cubit.gender == "Male",
                  onTap: () {
                    cubit.selectGender("Male");
                  },
                ),
                SizedBox(width: SizeConfig.width * 0.04),
                GenderCard(
                  key: const Key("female"),
                  genderName: tr.female,
                  isSelected: cubit.gender == "Female",
                  genderIcon: FontAwesomeIcons.female,
                  onTap: () {
                    cubit.selectGender("Female");
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
