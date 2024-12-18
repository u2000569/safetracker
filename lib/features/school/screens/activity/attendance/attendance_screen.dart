import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:safetracker/common/widgets/loaders/loading_animate.dart';
import 'package:safetracker/features/school/controllers/grade_controller.dart';
import 'package:safetracker/features/school/screens/activity/attendance/widgets/nfc_screen.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../controllers/student/student_controller.dart';
import 'students_table/students_table.dart';

class AttendanceScreen extends StatelessWidget {
  final GradeController gradeController = Get.put(GradeController());

  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentController = Get.put(StudentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.to(() => NFCscreen(action: 'check in',)),
                    child: const Text('Check In'),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.to(() => NFCscreen(action: 'check out',)),
                    child: const Text('Check Out'),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              // Obx(() {
              //   if (gradeController.isLoading.value) {
              //     return const Center(child: CircularProgressIndicator());
              //   } else {
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemCount: gradeController.allGrades.length,
              //       itemBuilder: (context, index) {
              //         final grade = gradeController.allGrades[index];
              //         return ListTile(
              //           title: Text(grade.name),
              //           subtitle: Text(grade.studentsCount.toString()),
              //         );
              //       },
              //     );
              //   }
              // }),
              const SizedBox(height: SSizes.spaceBtwItems),
              // table body
              Obx((){
                // show loader
                if(studentController.isLoading.value) return const SLoadingAnimate();

                return const SRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header

                      StudentsTable(),
                    ],
                  ),
                );

              }
              )

            ],
          ),
        ),
      ),
    );
  }
}