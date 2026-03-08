import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreenHeader extends StatelessWidget {
  const DoctorHomeScreenHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctorModel = getIt<CacheHelper>().getDoctorModel()!.doctor;
    final tr = context.tr;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                doctorModel!.image,
              ),
              radius: SizeConfig.width * 0.065,
            ),
            SizedBox(width: SizeConfig.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr.helloDr(doctorModel.name),
                    style: AppTextStyles.title18WhiteW500,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(tr.managePatientsToday,
                      style: AppTextStyles.title12White70),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pushScreen(RouteNames.settingsScreen);
              },
              child: Badge(
                backgroundColor: Colors.red,
                smallSize: SizeConfig.width * 0.025,
                child: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: SizeConfig.width * 0.065,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.height * 0.012),
        Text(
          tr.manageYour,
          style: AppTextStyles.title14White,
        ),
        Text(
          tr.patients,
          style: AppTextStyles.title22WhiteColorBold,
        ),
      ],
    );
  }
}
