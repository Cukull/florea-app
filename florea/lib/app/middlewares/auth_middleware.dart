import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:florea/controllers/auth_controller.dart';
import 'package:florea/app/app_routes.dart';

/// Guard auth untuk route protected. Ditempel via `middlewares`
/// di tiap GetPage (lihat app_pages.dart).
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthController>()) return null;
    final auth = Get.find<AuthController>();
    final goingAuth =
        route == Routes.login || route == Routes.register;
    if (!auth.isLoggedIn.value &&
        !goingAuth &&
        route != Routes.forgotPassword &&
        route != Routes.verify) {
      return const RouteSettings(name: Routes.login);
    }
    if (auth.isLoggedIn.value &&
        !auth.onboardingDone.value &&
        route != Routes.onboarding) {
      return const RouteSettings(name: Routes.onboarding);
    }
    if (auth.isLoggedIn.value &&
        auth.onboardingDone.value &&
        (goingAuth || route == Routes.onboarding)) {
      return const RouteSettings(name: Routes.main);
    }
    return null;
  }
}
