import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_theme.dart';
import 'app_pages.dart';
import 'app_routes.dart';
import 'bindings/app_bindings.dart';

class FloreaApp extends StatelessWidget {
  const FloreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Florea',
      theme: AppTheme.light,
      initialRoute: Routes.login,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}
