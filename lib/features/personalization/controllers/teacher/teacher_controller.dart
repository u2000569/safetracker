import 'package:get/get.dart';
import 'package:safetracker/features/personalization/models/user_model.dart';

import '../../../../data/repositories/teacher/teacher_repository.dart';

class TeacherController extends GetxController{
  static TeacherController get instance => Get.find();

  final _teacherRepository = Get.find<TeacherRepository>();

  @override
  Future<List<UserModel>> fetchTeacher() async{
    return await _teacherRepository.getTeacher();
  }
} 
  
