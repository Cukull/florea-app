import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Task')),
      body: Center(child: Text('Task $id (TODO F4)')),
    );
  }
}
