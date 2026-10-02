import 'package:get/get.dart';

import '../app/app_routes.dart';
import '../services/supabase_client.dart';

/// Session + onboarding state. Didaftarkan permanent di AppBindings.
/// Diisi dari Supabase session + tabel profiles saat splash/auth berubah.
class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final onboardingDone = false.obs;
  final isLoading = false.obs;

  void markSession({required bool loggedIn, required bool onboarded}) {
    isLoggedIn.value = loggedIn;
    onboardingDone.value = onboarded;
  }

  Future<void> logout() async {
    await Supa.client.auth.signOut();
    markSession(loggedIn: false, onboarded: false);
    Get.offAllNamed(Routes.login);
  }
}
