import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/main_controller.dart';

/// Binding awal aplikasi. Satu-satunya tempat Get.put/lazyPut global.
/// Binding per fitur ditambahkan di sini seiring controller baru lahir.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<MainController>(() => MainController());
  }
}
