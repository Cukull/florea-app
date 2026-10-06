import 'package:get/get.dart';

import 'package:florea/app/app_routes.dart';

/// Index bottom-tab + navigasi lintas tab.
/// Tab: 0 home · 1 planner · 2 focus · 3 wellness · 4 profile.
class MainController extends GetxController {
  static MainController get to => Get.find();

  final tabIndex = 0.obs;

  void switchTab(int i) => tabIndex.value = i;

  /// Pindah tab dari mana saja (termasuk dari halaman detail).
  void goTab(int i) {
    if (Get.currentRoute != Routes.main) {
      Get.offAllNamed(Routes.main);
    }
    switchTab(i);
  }
}
