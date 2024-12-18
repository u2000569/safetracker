import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/common/widgets/images/s_circular_image.dart';
import 'package:safetracker/common/widgets/shimmers/shimmer.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/models/student_model.dart';
import 'package:safetracker/features/school/screens/student_profile/change_student_name.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../personalization/screens/profile/change_name.dart';
import '../../../personalization/screens/profile/widgets/profile_menu.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentModel studentId;
  const StudentProfileScreen({
    super.key,
    required this.studentId,
    });

  @override
Widget build(BuildContext context) {
  final studentController = StudentController.instance;

  // Fetch student data if not already fetched
  if (studentController.student.value.id != studentId.id) {
    studentController.fetchStudentForId(studentId.id);
  }

  return Scaffold(
    appBar: SAppBar(
      showBackArrow: true,
      title: Text('Student Profile', style: Theme.of(context).textTheme.headlineSmall),
    ),
    body: Obx(() {
      if (studentController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final student = studentController.studentParent.value;
      SLoggerHelper.info('student data: $student');
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SCircularImage(
                      image: student!.thumbnail.isNotEmpty ? student.thumbnail : SImages.user,
                      width: 80,
                      height: 80,
                      isNetworkImage: student.thumbnail.isNotEmpty,
                    ),
                    TextButton(
                      onPressed: studentController.imageUploading.value
                          ? null
                          : () => studentController.uploadStudentProfilePicture(studentId.id),
                      child: const Text('Change Student Profile Picture'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              const Divider(),
              const SSectionHeading(title: 'Student Information', showActionButton: false),
              SProfileMenu(title: 'Name', value: student.name,onPressed: () => Get.to(() => const ChangeStudentName()),),
              SProfileMenu(title: 'ID Number', value: student.id ,onPressed: () {
                
              },),
              SProfileMenu(title: 'Grade', value: student.grade?.name ?? 'N/A',onPressed: () {
                
              },),
              const Divider(),
              const SSectionHeading(title: 'Parent Information', showActionButton: false),
              SProfileMenu(title: 'Parent Name', value: student.parent?.fullName ?? 'N/A',onPressed: () {
                
              },),
              SProfileMenu(title: 'Parent Email', value: student.parent?.email ?? 'N/A',onPressed: () {
                
              },),
              SProfileMenu(title: 'Phone Number', value: student.parent?.phoneNumber ?? 'N/A',onPressed: () {
                
              },),
            ],
          ),
        ),
      );
    }),
  );
}

}