import 'package:get/get.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../models/student_model.dart';

class StudentController extends SBaseController<StudentModel> {
  static StudentController get instance => Get.find();

  final isLoading = false.obs;
  final studentRepository = Get.put(StudentRepository());
  RxList<StudentModel> featuredStudents = <StudentModel>[].obs;
  final _studentRepository = Get.put(StudentRepository());

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

  @override
  Future<List<StudentModel>> fetchItems() async{
    sortAscending.value = false;
    return await _studentRepository.getAllStudents();
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (StudentModel student) => student.name.toLowerCase());
  }

  @override
  bool containsSearchQuery(StudentModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(StudentModel item) async {
    await _studentRepository.deleteStudent(item.docId);
  }


  
}