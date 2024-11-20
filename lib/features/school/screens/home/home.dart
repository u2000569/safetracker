import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:safetracker/common/widgets/layouts/grid_layout.dart';
import 'package:safetracker/common/widgets/shimmers/vertical_student_shimmer.dart';
import 'package:safetracker/common/widgets/student_cards/student_card_vertical.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/device/device_utility.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../all_students/all_students.dart';
import 'widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
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
                        futureMethod: StudentRepository.instance.getFeaturedStudents(),
                      ),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  // Student Section
                  Obx(
                    () {
                      // Display loader whilte student waiting
                      if(controller.isLoading.value) return const SVerticalStudentShimmer();

                      // Check if no student found
                      if(controller.featuredStudents.isEmpty){
                        return Center(child: Text('No student found', style: Theme.of(context).textTheme.bodyMedium));
                      } else {
                        // student found
                        // return Text('Student found');
                        return SGridLayout(
                          itemCount: controller.featuredStudents.length, 
                          itemBuilder: (_, index) =>
                            SStudentCardVertical(student: controller.featuredStudents[index], isNetworkImage: true),
                        );
                      }
                    }
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