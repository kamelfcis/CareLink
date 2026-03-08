import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/components/custom_icon_button.dart';
import 'package:care_link/core/utilies/assets/images/app_images.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/view_models/cubit/sign_up_as_doctor_cubit.dart';

class PickDoctorImage extends StatelessWidget {
  const PickDoctorImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignUpAsDoctorCubit>();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.0085,
        vertical: SizeConfig.height * 0.0085,
      ),
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.white, width: SizeConfig.width * 0.008),
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.kPrimaryColor.withOpacity(0.3),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: BlocBuilder<SignUpAsDoctorCubit, SignUpAsDoctorState>(
              buildWhen: (previous, current) => current is PickImageSuccess,
              builder: (context, state) {
                return CircleAvatar(
                  radius: SizeConfig.width * 0.14,
                  backgroundColor: AppColors.kPrimaryColor.withOpacity(0.3),
                  backgroundImage: cubit.image == null
                      ? AssetImage(AppImages.profileImage)
                      : FileImage(cubit.image!),
                );
              },
            ),
          ),
          Positioned(
            bottom: -SizeConfig.height * 0.008,
            right: SizeConfig.width * 0.18,
            child: CustomIconButton(
              iconSize: SizeConfig.width * 0.06,
              backgroundColor: AppColors.kPrimaryColor,
              iconColor: Colors.white,
              icon: Icons.camera_alt_outlined,
              onPressed: () {
                cubit.pickProfileImage();
              },
              hPadding: SizeConfig.width * 0.02,
              vPadding: SizeConfig.height * 0.01,
            ),
          ),
        ],
      ),
    );
  }
}
