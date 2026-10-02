import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class FloreaApp extends StatelessWidget {
  const FloreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Florea',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
