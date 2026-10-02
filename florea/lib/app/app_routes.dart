/// Konstanta named route GetX. Satu sumber kebenaran untuk navigasi.
abstract class Routes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verify = '/verify';
  static const onboarding = '/onboarding';

  /// Shell bottom-tab (IndexedStack): home | planner | focus | wellness | profile
  static const main = '/main';

  static const plannerCreate = '/planner/create';
  static const plannerDetail = '/planner/detail/:id';
  static const plannerEdit = '/planner/edit/:id';

  static const pomodoro = '/focus/pomodoro';
  static const deepFocus = '/focus/deep';
  static const examMode = '/focus/exam';
  static const focusHistory = '/focus/history';

  static const mood = '/wellness/mood';
  static const habits = '/wellness/habits';
  static const sleep = '/wellness/sleep';

  static const editProfile = '/profile/edit';
  static const settings = '/profile/settings';
  static const achievements = '/profile/achievements';
}
