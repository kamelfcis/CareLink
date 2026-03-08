import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/components/custom_elevated_button.dart';
import 'package:care_link/core/constants/app_constants.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/on_boarding/view_models/cubit/on_boarding_cubit.dart';
import 'package:care_link/features/on_boarding/views/widgets/custom_smoth_page_indecator.dart';
import 'package:care_link/features/on_boarding/views/widgets/on_boarding_page_view_builder.dart';
import 'package:care_link/features/splash/views/widgets/gradient_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingScreenBody extends StatelessWidget {
  const OnBoardingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingCubit, int>(
      listener: (context, state) {
        if (state == AppConstants.onBoardingStepsCount) {
          context.pushScreen(RouteNames.signInScreen);
        }
      },
      child: GradientBody(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.05,
              vertical: SizeConfig.height * 0.02,
            ),
            child: Column(
              children: [
                CustomSmoothPageIndecator(),
                SizedBox(height: SizeConfig.height * 0.02),
                const Expanded(child: OnBoardingPageViewBuilder()),
                SizedBox(height: SizeConfig.height * 0.03),
                NextButton(),
                SizedBox(height: SizeConfig.height * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, int>(
      buildWhen: (previous, current) => previous == 2 || current == 2,
      builder: (context, state) {
        return CustomElevatedButton(
          name: state == AppConstants.onBoardingStepsCount - 1
              ? context.tr.getStarted
              : context.tr.next,
          backgroundColor: AppColors.kPrimaryColor,
          width: double.infinity,
          hPadding: SizeConfig.height * 0.02,
          onPressed: () {
            context.read<OnBoardingCubit>().nextPage();
          },
        );
      },
    );
  }
}
