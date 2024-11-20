import 'package:get/get.dart';
import 'package:safetracker/data/repositories/grade/grade_repository.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/school/models/grade_model.dart';
import 'package:safetracker/features/school/models/student_model.dart';
import 'package:safetracker/utils/popups/loader.dart';

class GradeController extends GetxController {
  static GradeController get to => Get.find();

  RxBool isLoading = true.obs;
  RxList<GradeModel> allGrades = <GradeModel>[].obs;
  RxList<GradeModel> featureGrades = <GradeModel>[].obs;

  final gradeRepository = Get.put(GradeRepository());

  @override
  void onInit() {
    super.onInit();
    fetchGrades();
  }

  /// --------------------- Load Grades ---------------------
  Future<void> fetchGrades() async{
    try {
      isLoading.value = true;

      final fetchedCategories = await gradeRepository.getAllGrade();
      //  UPdate all grades list
      allGrades.assignAll(fetchedCategories);

      //update feature grades list
      //featureGrades.assignAll(allGrades.where((grade) => grade.name ?? false).take(4).toList());
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Oh snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Get Grade Specific Students from datd source
  Future<List<StudentModel>> getGradeStudents(String gradeId, int limit) async{
    final students = await StudentRepository.instance.getStudentsForGrade(gradeId, limit);
    return students;
  }
}