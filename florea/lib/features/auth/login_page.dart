import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          // Dummy: setelah AuthController terisi, pakai offAllNamed ke /main.
          onPressed: () => Get.offAllNamed(Routes.main),
          child: const Text('Masuk (dummy) ke Home'),
        ),
      ),
    );
  }
}
