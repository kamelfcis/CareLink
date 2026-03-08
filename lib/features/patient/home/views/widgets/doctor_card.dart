import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/patient/home/views/widgets/doctor_image.dart';
import 'package:care_link/features/patient/home/views/widgets/doctor_review.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor});
  final DoctorModel doctor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: SizeConfig.height * 0.045,
            bottom: SizeConfig.height * 0.015,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.04,
            vertical: SizeConfig.height * 0.015,
          ),
          constraints: BoxConstraints(
            minHeight: SizeConfig.height * 0.16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.kPrimaryColor,
                AppColors.kPrimaryColor.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: SizeConfig.width * 0.22),
                        Expanded(
                          child: Text(
                            doctor.doctor!.name,
                            style: AppTextStyles.title18WhiteBold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width * 0.02,
                              vertical: SizeConfig.height * 0.004,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "${doctor.specialty.icon ?? ''}  ${doctor.specialty.name}",
                              style: AppTextStyles.title12WhiteW500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        DoctorReview(),
                      ],
                    ),
                    SizedBox(height: SizeConfig.height * 0.008),
                    Text(
                      doctor.bio,
                      style: AppTextStyles.title12White70,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DoctorImage(doctorImage: doctor.doctor!.image),
      ],
    );
  }
}
