import 'package:go_router/go_router.dart';

import '../features/auth/login_page.dart';
import '../features/focus/focus_page.dart';
import '../features/home/home_page.dart';
import '../features/planner/planner_page.dart';
import '../features/profile/profile_page.dart';
import '../features/wellness/wellness_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/home', builder: (_, _) => const HomePage()),
    GoRoute(path: '/planner', builder: (_, _) => const PlannerPage()),
    GoRoute(path: '/focus', builder: (_, _) => const FocusPage()),
    GoRoute(path: '/wellness', builder: (_, _) => const WellnessPage()),
    GoRoute(path: '/profile', builder: (_, _) => const ProfilePage()),
  ],
);
