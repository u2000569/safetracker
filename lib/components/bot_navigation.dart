import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/screens/homescreen/parenthomescreen.dart';
import 'package:safetracker/screens/homescreen/teacherhomescreen.dart';
import 'package:safetracker/screens/activityscreen.dart';
import 'package:safetracker/screens/notificationscreen.dart';
import 'package:safetracker/screens/profilescreen.dart';

class BottomNav extends StatelessWidget {
  final String role;
  final Logger _logger = Logger();  // Adding the logger instance

  BottomNav({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    // Log the role being used in this instance of BottomNav
    _logger.i("BottomNav initialized with role: $role");

    // Determine which screens to show based on the role
    List<NavigationDestination> destinations;
    List<Widget> screens;

    if (role == 'Parent') {
      destinations = const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.local_activity), label: 'Activity'),
        NavigationDestination(icon: Icon(Icons.notifications), label: 'Notification'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ];

      screens = [
        const ParentHomeScreen(),
        const ActivityScreen(),
        NotificationScreen(),
        const OldProfileScreen(),
      ];
    } else if (role == 'Teacher') {
      destinations = const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.local_activity), label: 'Activity'),
        NavigationDestination(icon: Icon(Icons.notifications), label: 'Notification'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ];

      screens = [
        const TeacherHomeScreen(),
        const ActivityScreen(),
        NotificationScreen(),
        const OldProfileScreen(),
      ];
    } else {
      // Handle roles that are unknown or default case
      destinations = const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      ];

      screens = [
        const Center(child: Text('No role assigned')), // A fallback screen
      ];
    }

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            _logger.i("Navigating to index: $index");  // Log navigation actions
            controller.selectedIndex.value = index;
          },
          destinations: destinations,
        ),
      ),
      body: Obx(() {
        return screens[controller.selectedIndex.value];
      }),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
}
