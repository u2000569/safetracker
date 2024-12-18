import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/features/personalization/screens/setting/setting.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/helpers/helper_functions.dart';
import 'package:safetracker/utils/logging/logger.dart';

import 'data/repositories/user/user_repository.dart';
import 'features/personalization/controllers/user_controller.dart';
import 'features/school/screens/activity/activity_screen.dart';
import 'features/school/screens/home/home.dart';
import 'features/school/screens/home/home_teacher.dart';

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
          destinations: controller.getNavigationDestinations(),
          )
      ),
      body: Obx(() => controller.screens[controller.selectedMenu.value]),
    );
  }

  
}

class AppScreenController extends GetxController {
    static AppScreenController get instance => Get.find();
    
    final Rx<int> selectedMenu = 0.obs;
    final RxList<Widget>  screens = <Widget>[].obs;
    final RxList<NavigationDestination> navigationDestinations = <NavigationDestination>[].obs;

    @override
    void onInit(){
      super.onInit();
      // Ensure UserController is available
      if (!Get.isRegistered<UserController>()) {
        Get.put(UserController());
      }
      _setupScreensAndDestinations();
    }

    void _setupScreensAndDestinations() async{
      // Fetch User Role from UserController
      // final userRole = Get.find<UserController>().user.value.role;
      final userController = Get.put(UserController());
      final userRepository = Get.put(UserRepository());

      final userRole = await userRepository.fetchUserRole();
      SLoggerHelper.debug('User Role: $userRole');

      if (userController.user.value.id == null || userController.user.value.id!.isEmpty) {
      // Ensure we fetch user details only if not already done
      userController.fetchUserDetails();
      }
      
      SLoggerHelper.info('User Role: $userController.user.value.role');

      if (userRole.roles == 'teacher') {
        screens.assignAll([
          const HomeTeacherScreen(),
          const ActivityScreen(),
          const SettingsScreen(),
        ]);
        navigationDestinations.assignAll([
          const NavigationDestination(icon: Icon(Iconsax.home), label: 'Home Teacher'),
          const NavigationDestination(icon: Icon(Iconsax.activity), label: 'Activity'),
          const NavigationDestination(icon: Icon(Iconsax.settings), label: 'Settings'),
        ]);
      } else if(userRole.roles == 'parent'){
        screens.assignAll([
          const HomeScreen(),
          const ActivityScreen(),
          const SettingsScreen(),
        ]);
        navigationDestinations.assignAll([
          const NavigationDestination(icon: Icon(Iconsax.home), label: 'Home Parent'),
          const NavigationDestination(icon: Icon(Iconsax.activity), label: 'Activity'),
          const NavigationDestination(icon: Icon(Iconsax.settings), label: 'Settings'),
        ]);
      }
    }
    List<NavigationDestination> getNavigationDestinations() => navigationDestinations;

    // final screens = [
    //   const HomeScreen(),
    //   // const SettingsScreen(),
    //   const ActivityScreen(),
    //   const SettingsScreen(),
    //   // const OldProfileScreen()
    // ];
}