import 'package:get/get.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../models/student_model.dart';

class StudentController extends GetxController {
  static StudentController get instance => Get.find();

  final isLoading = false.obs;
  final studentRepository = Get.put(StudentRepository());
  RxList<StudentModel> featuredStudents = <StudentModel>[].obs;

  //initialize the controller
  @override
  void onInit() {
    fetchFeaturedStudents();
    super.onInit();
  }

  void fetchFeaturedStudents() async{
    try {
      isLoading.value = true;

      final students = await studentRepository.getFeaturedStudents();

      // Assign students
      featuredStudents.assignAll(students);
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Oh snap!!!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  
}