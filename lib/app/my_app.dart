// ignore_for_file: deprecated_member_use
import 'package:care_link/core/app_route/app_routes.dart';
import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/locale/locale_cubit.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/l10n/app_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) {
              // Initialize SizeConfig here where MediaQuery is fully available
              SizeConfig.init(context);
              final deviceChild = DevicePreview.appBuilder(context, child);
              return deviceChild;
            },
            routes: AppRoutes.routes,
            initialRoute: RouteNames.splashScreen,
          );
        },
      ),
    );
  }
}
