import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/screens/home/home.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/full_screen_loader.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../utils/helpers/network_manager.dart';

class UpdateStudentNameController extends GetxController {
  static UpdateStudentNameController get instance => Get.find();

  final fullName = TextEditingController();
  final studentController = StudentController.instance;
  final studentRepository = Get.put(StudentRepository());
  GlobalKey<FormState> updateStudentNameFormKey = GlobalKey<FormState>();
  

  @override
  void onInit(){
    initializeStudentNames();
    super.onInit();
  } 

  /// fetch student record
  Future<void> initializeStudentNames() async{
    fullName.text = studentController.studentParent.value!.name;
  }

  Future<void> updateStudentName() async{
    try {
      SFullScreenLoader.openLoadingDialog('We are updating your information...', SImages.loaderAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        SFullScreenLoader.stopLoading();
        return;
      }
      final student = studentController.studentParent.value;
      if (student == null) {
      throw 'Student data is not available. Please reload and try again.';
      }
      SLoggerHelper.info('Updating student with ID: ${student.docId}');
      SLoggerHelper.info('New name: ${fullName.text.trim()}');

      Map<String, dynamic> name = {'name': fullName.text.trim()};
      await studentRepository.updateSingleField(student.docId, name);

      // update the Rx User value
      studentController.studentParent.value!.name = fullName.text.trim();

      // Remove Loader
      SFullScreenLoader.stopLoading();

      // Show Success Message
      SLoaders.successSnackBar(title: 'Success', message: 'Your information has been updated successfully');
      Get.off(() => const HomeScreen());
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}