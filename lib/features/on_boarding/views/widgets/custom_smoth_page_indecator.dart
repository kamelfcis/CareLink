import 'package:care_link/core/constants/app_constants.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/on_boarding/view_models/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothPageIndecator extends StatelessWidget {
  const CustomSmoothPageIndecator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: context.read<OnBoardingCubit>().pageController,
      count: AppConstants.onBoardingStepsCount,
      effect: SwapEffect(
        spacing: SizeConfig.width * 0.02,
        dotHeight: SizeConfig.height * 0.01,
        dotWidth: SizeConfig.height * 0.08,
        dotColor: Colors.grey[300]!,
        activeDotColor: AppColors.kPrimaryColor,
      ),
    );
  }
}
