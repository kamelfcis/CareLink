import 'package:flutter/widgets.dart';
import 'package:care_link/l10n/app_localizations.dart';

/// Convenient extension so screens can simply write `context.tr.someKey`.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;
}








