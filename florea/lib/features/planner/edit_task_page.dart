import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key});
  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Center(child: Text('Edit $id (TODO F4)')),
    );
  }
}
