import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/network/gemini/gemini_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  getIt.registerSingleton<CacheHelper>(cacheHelper);
  getIt.registerLazySingleton(() => Supabase.instance.client);
  getIt.registerLazySingleton(() => GeminiService());
}
