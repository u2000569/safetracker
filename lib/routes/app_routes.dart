import 'package:get/get.dart';
// import 'package:safetracker/bindings/general_bindings.dart';
import 'package:safetracker/features/authentication/screens/login/login.dart';
import 'package:safetracker/features/personalization/screens/setting/setting.dart';
import 'package:safetracker/features/school/screens/activity/activity_screen.dart';
import 'package:safetracker/features/school/screens/activity/attendance/widgets/nfc_screen.dart';
import 'package:safetracker/features/school/screens/home/home.dart';
import 'package:safetracker/home_menu.dart';
import 'package:safetracker/routes/routes.dart';
import 'package:safetracker/routes/routes_middleware.dart';

import '../features/personalization/screens/profile/profile.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: SRoutes.homeMenu, page: () => const HomeMenu()),
    GetPage(name: SRoutes.home , page: () => const HomeScreen(), middlewares: [SRouteMiddleware()]),
    GetPage(name: SRoutes.login , page: () => const LoginScreen()),
    GetPage(name: SRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: SRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: SRoutes.activity, page: () => const ActivityScreen()),
  ];
}