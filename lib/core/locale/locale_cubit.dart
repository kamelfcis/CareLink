import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_savedLocale());

  static const String _key = 'locale';

  static Locale _savedLocale() {
    final code = getIt<CacheHelper>().getDataString(key: _key);
    return Locale(code ?? 'en');
  }

  void toArabic() {
    getIt<CacheHelper>().saveData(key: _key, value: 'ar');
    emit(const Locale('ar'));
  }

  void toEnglish() {
    getIt<CacheHelper>().saveData(key: _key, value: 'en');
    emit(const Locale('en'));
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      toArabic();
    } else {
      toEnglish();
    }
  }

  bool get isArabic => state.languageCode == 'ar';
}








