import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Florea - Home')),
      body: Wrap(
        spacing: 12,
        children: [
          ElevatedButton(onPressed: () => context.go('/planner'), child: const Text('Planner')),
          ElevatedButton(onPressed: () => context.go('/focus'), child: const Text('Focus')),
          ElevatedButton(onPressed: () => context.go('/wellness'), child: const Text('Wellness')),
          ElevatedButton(onPressed: () => context.go('/profile'), child: const Text('Profile')),
        ],
      ),
    );
  }
}
