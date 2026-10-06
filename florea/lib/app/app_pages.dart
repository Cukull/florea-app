import 'package:get/get.dart';

import 'package:florea/features/auth/forgot_password_page.dart';
import 'package:florea/features/auth/login_page.dart';
import 'package:florea/features/auth/onboarding_page.dart';
import 'package:florea/features/auth/register_page.dart';
import 'package:florea/features/auth/verify_page.dart';
import 'package:florea/features/focus/deep_focus_page.dart';
import 'package:florea/features/focus/exam_mode_page.dart';
import 'package:florea/features/focus/focus_history_page.dart';
import 'package:florea/features/focus/pomodoro_page.dart';
import 'package:florea/features/planner/create_task_page.dart';
import 'package:florea/features/planner/edit_task_page.dart';
import 'package:florea/features/planner/task_detail_page.dart';
import 'package:florea/features/profile/achievements_page.dart';
import 'package:florea/features/profile/edit_profile_page.dart';
import 'package:florea/features/profile/settings_page.dart';
import 'package:florea/features/wellness/habits_page.dart';
import 'package:florea/features/wellness/mood_page.dart';
import 'package:florea/features/wellness/sleep_page.dart';
import 'package:florea/app/app_routes.dart';
import 'package:florea/app/main_shell.dart';
import 'package:florea/app/middlewares/auth_middleware.dart';

/// Daftar GetPage. AuthMiddleware menjaga route protected.
/// Jangan pecah list ini per fitur untuk MVP.
abstract class AppPages {
  static final routes = <GetPage>[
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.register, page: () => const RegisterPage()),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(name: Routes.verify, page: () => const VerifyPage()),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainShell(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.plannerCreate,
      page: () => const CreateTaskPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.plannerDetail,
      page: () => const TaskDetailPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.plannerEdit,
      page: () => const EditTaskPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.pomodoro,
      page: () => const PomodoroPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.deepFocus,
      page: () => const DeepFocusPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.examMode,
      page: () => const ExamModePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.focusHistory,
      page: () => const FocusHistoryPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.mood,
      page: () => const MoodPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.habits,
      page: () => const HabitsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.sleep,
      page: () => const SleepPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfilePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.achievements,
      page: () => const AchievementsPage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
