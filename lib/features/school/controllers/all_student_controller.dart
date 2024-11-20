import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:safetracker/features/school/models/student_model.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../data/repositories/student/student_repository.dart';

class AllStudentController extends GetxController{
  static AllStudentController get instance => Get.find();

  // final StudentRepository studentRepository = Get.put(StudentRepository());

  final repository = StudentRepository.instance;
  final RxString selectedSortOption = 'name'.obs;
  final RxList<StudentModel> students = <StudentModel>[].obs;

  Future<List<StudentModel>> fetchStudentByQuery(Query? query) async{
    // option 1
    try {
      if(query == null) return [];
      return await repository.fetchStudentByQuery(query);
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Oh snap!', message: e.toString());
      return [];
    }

    //option 2
    // try {
    //   if (query != null) {
    //     final querySnapshot = await query.get();
    //     return querySnapshot.docs.map((doc) => StudentModel.fromSnapshot(doc)).toList();
    //   } else {
    //     // return await studentRepository.getFeaturedStudents();
    //     return await repository.getFeaturedStudents();
    //   }
    // } catch (e) {
    //   print('Error fetching students: $e');
    //   return [];
    // }
  }

  void assignStudents(List<StudentModel> students){
    // assign students to the 'Studens' list
    this.students.assignAll(students);
    sortStudents('name');
  }

  void sortStudents(String sortOption){
    selectedSortOption.value = sortOption;
    switch (sortOption) {
      case 'name':
        students.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'grade':
        students.sort((a, b) => a.grade?.name.compareTo(b.grade?.name ?? '') ?? 0); // Ensure null safety
        break;
      default:
        students.sort((a, b) => a.name.compareTo(b.name));
    }
  }
}