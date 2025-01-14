import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/school/controllers/dismissalController/dismissal_controller.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../home_menu.dart';
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
  final RxList<StudentModel> studentParentList = <StudentModel>[].obs;

  final _db = FirebaseFirestore.instance;
  // to update the table
  RxList<StudentModel> filteredItems = <StudentModel>[].obs;

  //initialize the controller
  @override
  void onInit() {
    try {
      SLoggerHelper.info("Initializing StudentController...");
      fetchFeaturedStudents();
      // SLoggerHelper.info('Student Information  : ${studentParent.value}');
      // fetchStudentForParent(studentParent.value!.parent!.email);
      // filteredItems.refresh();
    } catch (e) {
      SLoggerHelper.error("Error during initialization: $e");
    }
    
    super.onInit();
  }

  void refreshTable() {
  update(); // Trigger a rebuild of the UI
  }

  void updateStudentList(StudentModel updateStudent){
    int index = filteredItems.indexWhere((student) => student.id == updateStudent.id);
    if(index == -1){
      SLoggerHelper.error('Student ${updateStudent.id} not found in the list');
    }
    filteredItems[index] = updateStudent;
    filteredItems.refresh();
  }

  void fetchFeaturedStudents() async{
    try {
      SLoggerHelper.info("Fetching featured students...");
      // Show loader while loading Products
      isLoading.value = true;
      // fetch student
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
        // studentParentList.assignAll(student.whereType<StudentModel>());
        studentParent.value = student; // Set the first student as the default
        SLoggerHelper.info("Student fetched successfully for parent: $parentEmail. Count: ${studentParentList.length}");
      } else{
        // studentParentList.clear(); // Clear the list if no students found
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
  uploadStudentProfilePicture(String studentDocId) async {
  try {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 512,
      maxWidth: 512,
    );

    if (image == null) {
      SLoaders.warningSnackBar(title: 'No Image Selected', message: 'Please select an image to upload.');
      return;
    }

    imageUploading.value = true;

    final storagePath = 'Users/Images/Profile/$studentDocId.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(storagePath);
    final uploadTask = await storageRef.putFile(File(image.path));
    final uploadedImageUrl = await uploadTask.ref.getDownloadURL();

    await studentRepository.updateSingleField(studentDocId, {'thumbnail': uploadedImageUrl});

    // Update the student object and refresh
    student.value.thumbnail = uploadedImageUrl;
    SLoggerHelper.info('Picture Link: $uploadedImageUrl');
    student.refresh(); // Refresh the state to notify observers

    imageUploading.value = false;
    SLoaders.successSnackBar(
      title: 'Success',
      message: 'Student profile picture updated successfully!',
    );
    Get.off(() => const HomeMenu());
  } catch (e) {
    SLoaders.errorSnackBar(title: 'Error', message: 'Failed to upload picture: $e');
  } finally {
    imageUploading.value = false;
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