import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:florea/core/theme/app_theme.dart';
import 'package:florea/app/app_pages.dart';
import 'package:florea/app/app_routes.dart';
import 'package:florea/app/bindings/app_bindings.dart';

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
