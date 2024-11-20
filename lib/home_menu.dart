import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/features/authentication/screens/login/login.dart';
import 'package:safetracker/features/personalization/screens/profile/profile.dart';
import 'package:safetracker/features/personalization/screens/setting/setting.dart';
import 'package:safetracker/screens/profilescreen.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/helpers/helper_functions.dart';

import 'features/school/screens/activity/activity_screen.dart';
import 'features/school/screens/home/home.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppScreenController());
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          animationDuration: const Duration(seconds: 3),
          selectedIndex: controller.selectedMenu.value,
          backgroundColor: SHelperFunctions.isDarkMode(context) ? SColors.black : Colors.white,
          elevation: 0,
          indicatorColor: SHelperFunctions.isDarkMode(context) ? SColors.white.withOpacity(0.1) : SColors.black.withOpacity(0.1),
          onDestinationSelected: (index) => controller.selectedMenu.value = index,
          destinations: const[
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            // NavigationDestination(icon: Icon(Icons.class_), label: 'Grade'),
            NavigationDestination(icon: Icon(Icons.notifications), label: 'Activity'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          )
      ),
      body: Obx(() => controller.screens[controller.selectedMenu.value]),
    );
  }

  
}

class AppScreenController extends GetxController {
    static AppScreenController get instance => Get.find();
    
    final Rx<int> selectedMenu = 0.obs;

    final screens = [
      const HomeScreen(),
      // const SettingsScreen(),
      const ActivityScreen(),
      const SettingsScreen(),
      // const OldProfileScreen()
    ];
}