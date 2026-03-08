import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/assets/lotties/app_lotties.dart';
import 'package:care_link/features/on_boarding/models/on_boarding_model.dart';
import 'package:flutter/material.dart';

class AppConstants {
  // on boarding list
  static List<OnBoardingStepModel> getOnBoardingList(BuildContext context) =>
      <OnBoardingStepModel>[
        OnBoardingStepModel(
          image: AppLotties.healthDataLottie,
          title: context.tr.onboardingNewTitle1,
          subTitle: context.tr.onboardingNewDesc1,
        ),
        OnBoardingStepModel(
          image: AppLotties.qrAccessLottie,
          title: context.tr.onboardingNewTitle2,
          subTitle: context.tr.onboardingNewDesc2,
        ),
        OnBoardingStepModel(
          image: AppLotties.aiAssistantLottie,
          title: context.tr.onboardingNewTitle3,
          subTitle: context.tr.onboardingNewDesc3,
        ),
        OnBoardingStepModel(
          image: AppLotties.privacyLottie,
          title: context.tr.onboardingNewTitle4,
          subTitle: context.tr.onboardingNewDesc4,
        ),
      ];

  static const int onBoardingStepsCount = 4;
  static final String qrCodeUrl = "http://carelink.somee.com/";
}
