import 'package:care_link/core/components/custom_circular_progress_indecator.dart';
import 'package:care_link/core/components/custom_elevated_button.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/patient/doctor_details/view_models/cubit/connect_with_doctor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectButton extends StatelessWidget {
  final String doctorId;

  const ConnectButton({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectWithDoctorCubit, ConnectWithDoctorState>(
        buildWhen: (p, c) =>
            c is ConnectWithDoctorLoading || p is ConnectWithDoctorLoading,
        builder: (context, state) {
          return state is ConnectWithDoctorLoading
              ? const CustomCircularProgresIndecator()
              : CustomElevatedButton(
                  name: context.tr.connect,
                  backgroundColor: AppColors.kPrimaryColor,
                  width: double.infinity,
                  hPadding: SizeConfig.height * 0.02,
                  onPressed: () {
                    context
                        .read<ConnectWithDoctorCubit>()
                        .connectWithDoctor(doctorId: doctorId);
                  },
                );
        });
  }
}
