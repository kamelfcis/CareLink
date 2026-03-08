import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/custom_failure_message.dart';
import 'package:care_link/features/doctor/home/view_models/cubit/patients_cubit.dart';
import 'package:care_link/features/doctor/home/views/widgets/empty_lottie.dart';
import 'package:care_link/features/doctor/home/views/widgets/patient_card.dart';
import 'package:care_link/features/patient/home/views/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientsListView extends StatelessWidget {
  const PatientsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PatientsCubit, PatientsState>(
        builder: (context, state) {
          if (state is GetPatientsLoading) {
            return CustomLoadingIndicator();
          } else if (state is GetPatientsError) {
            return CustomFailureMesage(errorMessage: state.errorMessage);
          }
          var patients = context.read<PatientsCubit>().patients;
          return patients.isEmpty
              ? EmptyLottie()
              : ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.pushScreen(RouteNames.patientDetailsScreen,
                            arguments: patients[index].toJson());
                      },
                      child: PatientCard(
                        key: ValueKey(patients[index].id),
                        patient: patients[index],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
