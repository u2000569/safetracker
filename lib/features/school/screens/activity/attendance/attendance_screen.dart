import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:safetracker/common/widgets/loaders/loading_animate.dart';
import 'package:safetracker/features/school/controllers/grade_controller.dart';
import 'package:safetracker/features/school/screens/activity/attendance/widgets/nfc_screen.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../controllers/student/student_controller.dart';
import 'students_table/students_table.dart';

class AttendanceScreen extends StatelessWidget {
  final GradeController gradeController = Get.put(GradeController());
  final studentController = StudentController();

  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // call student list
    studentController.refreshTable();
    final student = studentController.filteredItems;
    SLoggerHelper.info('Attendance Student List : ${student.toJson()}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: SSizes.spaceBtwItems),
                Expanded(
                  child: Obx(() {
                    // Show loader or table
                    if (studentController.isLoading.value) {
                      return const SLoadingAnimate();
                    }

                    return const SRoundedContainer(
                      child: Column(
                        children: [
                          // Table Header
                          Expanded(child: StudentsTable()), // Constrain the table height
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 80), // Add space for the floating buttons
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Get.to(() => NFCscreen(action: 'check in'), arguments: student);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.buttonPrimary,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    side: const BorderSide(color: SColors.white, width: 2),
                    elevation: 5,
                    shape: const StadiumBorder(),
                  ),
                  label: const Text('Check In'),
                ),
                const SizedBox(width: SSizes.spaceBtwItems),
                OutlinedButton.icon(
                  icon: const Icon(Icons.exit_to_app, color: SColors.primary,),
                  onPressed: () => Get.to(() => NFCscreen(action: 'check out'),arguments: student),
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    side: const BorderSide(color: SColors.primary, width: 2),
                    elevation: 5,
                    shape: const StadiumBorder(),
                  ),
                  label: const Text('Check Out', style: TextStyle(
                    color: SColors.primary
                  ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
