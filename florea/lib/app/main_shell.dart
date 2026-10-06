import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:florea/controllers/main_controller.dart';
import 'package:florea/features/focus/focus_page.dart';
import 'package:florea/features/home/home_page.dart';
import 'package:florea/features/planner/planner_page.dart';
import 'package:florea/features/profile/profile_page.dart';
import 'package:florea/features/wellness/wellness_page.dart';

/// Shell bottom-tab. Tab diganti via MainController (IndexedStack),
/// bukan route terpisah — state tiap tab terjaga.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: c.tabIndex.value,
          children: const [
            HomePage(),
            PlannerPage(),
            FocusPage(),
            WellnessPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: c.tabIndex.value,
          onTap: c.switchTab,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.calendarDays),
              label: 'Planner',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.timer),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.heartPulse),
              label: 'Wellness',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
