import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../models/student_model.dart';

class StudentController extends SBaseController<StudentModel> {
  static StudentController get instance => Get.find();

  Rx<StudentModel> student = StudentModel.empty().obs;
  final imageUploading = false.obs;
  final profileImageUrl = ''.obs;

  final isLoading = false.obs;
  final studentRepository = Get.put(StudentRepository());
  RxList<StudentModel> featuredStudents = <StudentModel>[].obs;
  final _studentRepository = Get.put(StudentRepository());
  final studentParent = Rx<StudentModel?>(null);

  final _db = FirebaseFirestore.instance;

  //initialize the controller
  @override
  void onInit() {
    try {
      SLoggerHelper.info("Initializing StudentController...");
      fetchFeaturedStudents();
    } catch (e) {
      SLoggerHelper.error("Error during initialization: $e");
    }
    
    super.onInit();
  }

  void fetchFeaturedStudents() async{
    try {
      SLoggerHelper.info("Fetching featured students...");
      isLoading.value = true;

      final students = await studentRepository.getFeaturedStudents();

      // Assign students
      featuredStudents.assignAll(students);
      SLoggerHelper.info("Featured students fetched successfully. Count: ${students.length}");
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Oh snap!!!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // fetch student ID
  Future<void> fetchStudentForId(String studentId) async{
    try {
      isLoading.value = true;
      final snapshot = await StudentRepository.instance.fetchStudentId(studentId);
      if(snapshot != null){
        studentParent.value = snapshot;
        SLoggerHelper.info('Student fetched successfully: $studentId');
      }else{
        studentParent.value = null;
        SLoggerHelper.warning('Cannot find student with ID: $studentId');
      }
    } catch (e) {
      SLoggerHelper.error('Error fetching student: $e');
    }
    isLoading.value = false;
  }

  Future<void> fetchStudentForParent(String parentEmail) async{
    try {
      SLoggerHelper.info("Fetching student for parent with email: $parentEmail");
      isLoading.value = true;
      final student = await StudentRepository.instance.fetchStudentParent(parentEmail);
      SLoggerHelper.info('Student for parent: $student');
      if (student != null) {
        studentParent.value = student;
        SLoggerHelper.info("Student fetched successfully for parent: $parentEmail");
      } else{
        studentParent.value = null;
        SLoggerHelper.warning('Cannot find student for parent: $parentEmail');
      }
    } catch (e) {
      SLoggerHelper.error('Error fetching student for parent: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void streamfetchStudentForParent(String parentEmail){
    _db.collection('Students')
    .where('Parent.Email', isEqualTo: parentEmail)
    .snapshots()
    .listen((querySnapshot) { 
      featuredStudents.value = querySnapshot.docs.map((doc){
        return StudentModel.fromSnapshot(doc);
      }).toList();

    if(featuredStudents.isNotEmpty){
      studentParent.value = featuredStudents.first;
    } else{
      studentParent.value = null;
    }
    isLoading.value = false;
    }, onError: (error){
      isLoading.value = false;
      SLoggerHelper.error('Error fetching student for parent: $error');
    }
    );
  }

  // Upload Student Picture
  uploadStudentProfilePicture(String studentId) async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80, maxHeight: 512, maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        final uploadedImage = await studentRepository.uploadImage('Users/Images/Profile/', image);
        profileImageUrl.value = uploadedImage;
        Map<String, dynamic> newImage = {'thumbnail': uploadedImage};
        await studentRepository.updateSingleField(studentId ,newImage);
        student.value.thumbnail = uploadedImage;
        student.refresh();

        imageUploading.value = false;
        SLoaders.successSnackBar(title: 'Congratulations', message: 'student profile picture has been updated successfully.');
      } 
    } catch (e) {
      imageUploading.value = false;
      SLoaders.errorSnackBar(title: 'OhSnap', message: 'Cannot upload picture. Something went wrong: $e');
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