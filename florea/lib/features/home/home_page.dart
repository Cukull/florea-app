import 'package:flutter/material.dart';

import 'package:florea/controllers/main_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Florea - Home')),
      body: Wrap(
        spacing: 12,
        children: [
          ElevatedButton(
            onPressed: () => MainController.to.goTab(1),
            child: const Text('Planner'),
          ),
          ElevatedButton(
            onPressed: () => MainController.to.goTab(2),
            child: const Text('Focus'),
          ),
          ElevatedButton(
            onPressed: () => MainController.to.goTab(3),
            child: const Text('Wellness'),
          ),
          ElevatedButton(
            onPressed: () => MainController.to.goTab(4),
            child: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
