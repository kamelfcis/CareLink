import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/patient/my_doctors/view_models/cubit/my_doctors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDoctorsScreen extends StatelessWidget {
  const MyDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyDoctorsCubit(),
      child: const _MyDoctorsBody(),
    );
  }
}

class _MyDoctorsBody extends StatelessWidget {
  const _MyDoctorsBody();

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kPrimaryColor.withOpacity(0.7),
              Colors.grey.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.04,
                  vertical: SizeConfig.height * 0.015,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(SizeConfig.width * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: SizeConfig.width * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.width * 0.03),
                    Container(
                      padding: EdgeInsets.all(SizeConfig.width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: SizeConfig.width * 0.055,
                      ),
                    ),
                    SizedBox(width: SizeConfig.width * 0.025),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.myDoctors,
                            style: AppTextStyles.title18WhiteBold,
                          ),
                          Text(
                            tr.doctorsConnectedWith,
                            style: AppTextStyles.title12White70,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: BlocBuilder<MyDoctorsCubit, MyDoctorsState>(
                    builder: (context, state) {
                      if (state is MyDoctorsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is MyDoctorsFailure) {
                        return _buildErrorView(context, state.errorMessage);
                      }
                      final doctors =
                          context.read<MyDoctorsCubit>().myDoctors;
                      if (doctors.isEmpty) {
                        return _buildEmptyView(context);
                      }
                      return _buildDoctorsList(context, doctors);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context, List<DoctorModel> doctors) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.04,
        vertical: SizeConfig.height * 0.02,
      ),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return _DoctorCard(doctor: doctor);
      },
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final tr = context.tr;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.06),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: SizeConfig.width * 0.15,
                color: AppColors.kPrimaryColor.withOpacity(0.5),
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            Text(
              tr.noConnectedDoctors,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.01),
            Text(
              tr.noConnectedDoctorsDesc,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    final tr = context.tr;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: SizeConfig.width * 0.15,
              color: Colors.red.shade300,
            ),
            SizedBox(height: SizeConfig.height * 0.02),
            Text(
              tr.somethingWentWrong,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.height * 0.02),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MyDoctorsCubit>().getMyDoctors();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(tr.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== DOCTOR CARD ===================== */

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return GestureDetector(
      onTap: () {
        context.pushScreen(
          RouteNames.doctorDetailsScreen,
          arguments: doctor.toJson(),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.height * 0.015),
        padding: EdgeInsets.all(SizeConfig.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Doctor avatar
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.kPrimaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: SizeConfig.width * 0.075,
                backgroundImage: doctor.doctor != null
                    ? NetworkImage(doctor.doctor!.image)
                    : null,
                child: doctor.doctor == null
                    ? Icon(Icons.person,
                        size: SizeConfig.width * 0.07,
                        color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(width: SizeConfig.width * 0.035),
            // Doctor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.doctor?.name ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (doctor.specialty.icon != null) ...[
                        Text(
                          doctor.specialty.icon!,
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          doctor.specialty.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.hospital,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.02),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: SizeConfig.width * 0.04,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}








