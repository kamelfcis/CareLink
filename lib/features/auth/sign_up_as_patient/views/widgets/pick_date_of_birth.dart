import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:care_link/core/components/custom_text_form_field_with_title.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_patient/view_models/cubit/sign_up_as_patient_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PickDateOfBirth extends StatelessWidget {
  const PickDateOfBirth({super.key, required this.cubit});
  final SignUpAsPatientCubit cubit;
  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<SignUpAsPatientCubit, SignUpAsPatientState>(
      buildWhen: (p, c) => c is UpdateDateOfBirth,
      builder: (context, state) {
        return CustomTextFormFieldWithTitle(
          enableValidator: false,
          title: tr.dateOfBirth,
          hintText: cubit.dateOfBirth == null
              ? tr.selectYourDateOfBirth
              : cubit.dateOfBirth.toString(),
          prefixIcon: CupertinoIcons.calendar,
          keyboardType: TextInputType.datetime,
          onTap: () {
            BottomPicker.date(
              headerBuilder: (context) {
                return Row(
                  children: [
                    Text(
                      tr.setYourBirthday,
                      style: AppTextStyles.title16PrimaryColorW500,
                    ),
                  ],
                );
              },
              dateOrder: DatePickerDateOrder.dmy,
              initialDateTime: DateTime(1996, 10, 22),
              maxDateTime: DateTime(1998),
              minDateTime: DateTime(1980),
              onChange: (index) {
                print(index);
              },
              onSubmit: (index) {
                cubit.selectDate(DateFormat()
                    .add_yMMMEd()
                    .format(DateTime.parse(index.toString())));
                print(index);
              },
              onDismiss: (p0) {
                print(p0);
              },
              bottomPickerTheme: BottomPickerTheme.plumPlate,
              buttonSingleColor: AppColors.kPrimaryColor,
            ).show(context);
          },
        );
      },
    );
  }
}
