import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/screens/activity/attendance/attendance_screen.dart';
import 'package:safetracker/features/school/screens/activity/emergency/emergency_screen.dart';
import 'package:safetracker/features/school/screens/home/widgets/quick_buttons.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/device/device_utility.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../all_students/all_students.dart';
import 'widgets/home_appbar.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
    final userController = Get.put(UserController());
    final studentRepository = Get.put(StudentRepository());
    final teacherEmail = userController.user.value.email;

    SLoggerHelper.info('Teacher Email: $teacherEmail');

    // Ensure user details are fetched when the app bar is loaded
    if (userController.user.value.id == null || userController.user.value.id!.isEmpty) {
      // Ensure we fetch user details only if not already done
      userController.fetchUserDetails();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
             const SPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -- Appbar
                  SHomeAppBar(),
                  SizedBox(height: SSizes.spaceBtwSections),

                  // -- Search Bar
                  // SSearchContainer(text: 'Search in class', showBorder: false),
                ],
              ),
            ),

            // Body
            Container(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Home'),
                  SSectionHeading(
                    title: 'Students',
                    onPressed: () => Get.to(
                      () => AllStudents(
                        title : 'All Students',
                        futureMethod: StudentRepository.instance.getAllStudents(),
                      ),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QuickActionButton(
                        icon: Iconsax.add_circle, 
                        label: 'Attendance', 
                        onPressed: () {
                          Get.to(AttendanceScreen());
                        }
                      ),
                      QuickActionButton(
                        icon: Iconsax.warning_2, 
                        label: 'Emergency', 
                        onPressed: () {
                          Get.to(const EmergencyScreen());
                        }
                      ),
                      QuickActionButton(
                        icon: Iconsax.add_circle, 
                        label: 'Dismissal', 
                        onPressed: () {}
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QuickActionButton(
                        icon: Iconsax.profile,
                        label: 'Students',
                        onPressed: (){

                        },
                      )
                    ],
                  ),
                  
                  

                  SizedBox(height: SDeviceUtils.getBottomNavigationBarHeight() + SSizes.defaultSpace),
                  
                ],
              )
            ),
          ]
        )
      ),
    );
  }
}




