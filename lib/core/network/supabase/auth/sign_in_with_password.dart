import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/error/supabase_exceptions.dart';
import 'package:care_link/core/network/supabase/auth/handel_auth_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signInWithPassword(
    {required String email, required String password}) async {
  final normalizedEmail = email.trim().toLowerCase();
  try {
    await getIt<SupabaseClient>()
        .auth
        .signInWithPassword(email: normalizedEmail, password: password);
  } on AuthException catch (e) {
    throw SupabaseExceptions(errorMessage: handleAuthError(e));
  } catch (e) {
    throw SupabaseExceptions(errorMessage: e.toString());
  }
}
