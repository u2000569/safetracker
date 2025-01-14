import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../../data/repositories/dismissal/dismissal_repository.dart';
import '../../../../home_menu.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/dismissal_model.dart';
import '../student/student_controller.dart';

class DismissalController extends GetxController{
  static DismissalController get instance => Get.find();

  // Variable
  final studentController = Get.put(StudentController());
  final userController = Get.put(UserController());
  
  final dismissalRepository = Get.put(DismissalRepositpory());

  // authorize user variable
  final authorized = false.obs;
  final authorizeName = TextEditingController();
  final authorizePhone = TextEditingController();

  final dismissalFormKey = GlobalKey<FormState>();
  Rx<DismissalModel> dismissal = DismissalModel.empty().obs;
  final imageUploading = false.obs;
  final isLoading = false.obs;

  // Observables for categorized students
  final studentsByParent = <Map<String, dynamic>>[].obs;
  final studentsByAuthorizedPerson = <Map<String, dynamic>>[].obs;
  final studentsWalkingOrBicycling = <Map<String, dynamic>>[].obs;

  // fucntion GetX Dismissal
  final studentsWithDismissals = <Map<String, dynamic>>[].obs;

  final _db = FirebaseFirestore.instance;


  // initialize the controller
  @override
  void onInit() {
    try {
      super.onInit();
      SLoggerHelper.info('Initializing DismissalController...');

      ever(studentController.studentParent, (student){
        if(student != null){
          final studentId = student.docId;
          final dismissalId = AuthenticationRepository.instance.getUserId;

          if(studentId.isNotEmpty && dismissalId.isNotEmpty){
            SLoggerHelper.info('fetching student dismissal for $studentId by $dismissalId');
            fetchStudentDismissal(studentId, dismissalId);
          } else{
            SLoggerHelper.warning('Student ID or Dismissal ID is empty');
          }
        } else{
          SLoggerHelper.warning('StudentParent Data is null');
        }
      });
      // final studentId = studentController.studentParent.value!.docId;
      
      // final dismissalId = AuthenticationRepository.instance.getUserId;
      // fetchStudentDismissal('GdUf7dhl9oMIbYuCjBj7', dismissalId);
      // SLoggerHelper.info('Fetching student dismissal for studentId by $dismissalId');
      fetchAllDismissals();
      SLoggerHelper.info('Fetching all dismissals....');
    } catch (e) {
      SLoggerHelper.error('Error during initialization: $e');
    }
  }



  // Fetch All Student Dismissals
  Future<void> fetchAllDismissals() async{
    try {
      isLoading.value = true;

      // Fetch all dismissals
      final allDismissal = await dismissalRepository.fetchAllDismissals();

      if(allDismissal.isNotEmpty){
        SLoggerHelper.info('Fetching all dismissals successful');
      } else{
        SLoggerHelper.warning('Warning: No Dismissal Document found');
      }
    } catch (e) {
      SLoggerHelper.error('Error fetching students with dismissals: $e');
    } finally{
      isLoading.value = false;
    }
  }

  // Stream Builder for Dismissal
  Stream<List<Map<String, dynamic>>> streamDismissal(String category) async*{
    try {
      SLoggerHelper.info('Streaming dismissals for category: $category ...');
      final studentSnapshot = await _db.collection('Students').get();

      final List<Map<String, dynamic>> fetchedStudents = [];

      for(final student in studentSnapshot.docs){
        final studentData = student.data();

        SLoggerHelper.info('Processing student: ${student.id}, Data: $studentData');
        final gradeName = studentData['Grade'] ? ['Name'] ?? 'Unknown';
        SLoggerHelper.info('Grade Name: $gradeName');

        final dismissalSnapshot=  await _db
          .collection('Students')
          .doc(student.id)
          .collection('DismissalRequest')
          .where('dismissalCategory', isEqualTo: category)
          .get();

          for(final doc in dismissalSnapshot.docs){
            SLoggerHelper.info('Found Dismissal: ${doc.data()}');

            fetchedStudents.add({
              'studentId': student.id,
              'name': studentData['name'] ?? 'Unknown',
              'grade': gradeName,
              ...doc.data(),
            });
          }


          

          // await for (final snapshot in dismissalStream){
          //   if(snapshot.docs.isNotEmpty){
          //     final studentInfo = {
          //       'studentId': student.id,
          //       'name': student.data()['name'] ?? 'Unknown',
          //       'class': student.data()['class'] ?? 'Unknown',
          //       'dismissalRequests': snapshot.docs.map((doc) => doc.data()).toList(),
          //     };
          //     fetchedStudents.add(studentInfo);
          //   }
          // }
      }
      // yield fetchedStudents;
      SLoggerHelper.info('Dismissal Stream: $fetchedStudents');
      yield fetchedStudents;
    } catch (e) {
      SLoggerHelper.error('Error streaming dismissals: $e');
    }
  }

  // using GetX
  void fetchDismissals(String category) async{
    try {
      studentsWithDismissals.clear();
      final studentSnapshot = await _db.collection('Students').get();

      final List<Map<String, dynamic>> fetchedStudents = [];

      for(final student in studentSnapshot.docs){
        final studentId = student.id;
        final studentData = student.data();

        // Access Grade Name
        final gradeName = studentData['Grade'] ? ['Name'] ?? 'Unknown';

        // fetch Dismissal Requests
        final dismissalSnapshot = await _db
          .collection('Students')
          .doc(studentId)
          .collection('DismissalRequest')
          .where('dismissalCategory', isEqualTo: category)
          .get();

          for(final doc in dismissalSnapshot.docs){
            SLoggerHelper.info('Found Dismissal: ${doc.data()}');

            fetchedStudents.add({
              'studentId': studentId,
              'name': studentData['name'] ?? 'Unknown',
              'grade': gradeName,
              ...doc.data(),
            });
          }
      }
      studentsWithDismissals.value = fetchedStudents;
    } catch (e) {
      SLoggerHelper.error('Error fetching dismissals: $e');
    }
  }

  // Fetch Student Dismissals By Category
  Future<void> fetchCategoryDismissal() async{
    try {
      isLoading.value = true;


      // fetch all students
      // final studentSnapshot = await 

      // final List<Map<String, dynamic>> byParent = [];
      // final List<Map<String, dynamic>> byAuthorizedPerson = [];
      // final List<Map<String, dynamic>> walkingOrBicycling = [];

      // Check Dismissal Requests for each student
      // for(final student in studentSnapshot.docs){}

      

    } catch (e) {
      
    }
  }

  // fetch Target Student Dismissal
  Future<void> fetchStudentDismissal(String studentId, String dismissalId) async{
    try {
      isLoading.value = true;
      final studentDismissalDoc = await dismissalRepository.fetchStudentDismissal(studentId, dismissalId);

      if(studentDismissalDoc != null){
        SLoggerHelper.info('Fetching student dismissal successful');
        dismissal.value = studentDismissalDoc;
      } else{
        SLoggerHelper.warning('Warning: No Dismissal Document found for $studentId');
        dismissal.value = DismissalModel.empty();
      }
      
    } catch (e) {
      SLoggerHelper.error('Error fetching student dismissal: $e');
    } finally{
      isLoading.value = false;
    }
  }

  // Create Dismissal
  // Did not use it in the project
  Future<void> createDismissal(String studentName) async{
    try {
      SLoggerHelper.info('Creating dismissal for $studentName');
      final dismissal = DismissalModel(
        id: AuthenticationRepository.instance.getUserId,
        status: 'Calling', 
        requestTime: DateTime.now(), 
        // pickupTime: null,
        authorized: false,
        authorizedPickupId: '',
        authorizedPickupName: '',
        authorizedPickupPhone: '',
        authorizedPickupImage: '',
      );

      SLoggerHelper.info('Dismissal ID: ${dismissal.id}');

      // send dismissal
      await dismissalRepository.createDismissal(dismissal);
      Get.off(() => const HomeMenu());
    } catch (e) {
      SLoggerHelper.error('Error creating dismissal: $e');
    }
  }

  // Dismissal authorization
  // Used in DismissalRequest
  Future<void> createRequestDismissal(String studentId) async{
    try {
      SLoggerHelper.info('Sending dismissal request for $studentId');
      final newDismissal = DismissalModel(
        id: AuthenticationRepository.instance.getUserId,
        status: 'Pending', 
        requestTime: DateTime.now(), 
        // pickupTime: null,
        authorized: true,
        authorizedPickupId: '',
        authorizedPickupName: authorizeName.text.trim(),
        authorizedPickupPhone: authorizePhone.text.trim(),
        authorizedPickupImage: '',
      );

      await dismissalRepository.createrequestDismissal(studentId, newDismissal.id, newDismissal);

      dismissal.value.authorizedPickupName = authorizeName.text.trim();
      dismissal.value.authorizedPickupPhone = authorizePhone.text.trim();
      dismissal.refresh();
      

      // Get.offAll(() => const DismissalScreen());
    } catch (e) {
      SLoggerHelper.error('Error sending dismissal request: $e');
    }
  }

  // Dismissal authorization
  // Used in DismissalRequest
  Future<void> updateRequestDismissal(String studentId) async{
    try {
      SLoggerHelper.info('Sending dismissal request for $studentId');
      final newDismissal = DismissalModel(
        id: AuthenticationRepository.instance.getUserId,
        status: 'Calling', 
        requestTime: DateTime.now(), 
        // pickupTime: null,
        authorized: true,
        authorizedPickupId: '',
        authorizedPickupName: authorizeName.text.trim(),
        authorizedPickupPhone: authorizePhone.text.trim(),
        // authorizedPickupImage: '',
      );

      await dismissalRepository.updateRequestDismissal(studentId, newDismissal.id, newDismissal);

      dismissal.value.authorizedPickupName = authorizeName.text.trim();
      dismissal.value.authorizedPickupPhone = authorizePhone.text.trim();
      dismissal.refresh();
      

      // Get.offAll(() => const DismissalScreen());
    } catch (e) {
      SLoggerHelper.error('Error sending dismissal request: $e');
    }
  }

  // UploadPicture Dismissal
  // Used in DismissalRequest
  uploadAuthorizedPicture(String studentDocId, String dismissalId, String imagePath) async{
    try {
      imageUploading.value = true;

      // Define the storage path in Firebase Storage
      final storagePath = 'Users/Images/Authorized/$dismissalId.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      // Upload the selected image to Firebase Storage
      final uploadTask = await storageRef.putFile(File(imagePath));
      final uploadImageUrl = await uploadTask.ref.getDownloadURL();

      
      SLoggerHelper.info('Picture Link: $uploadImageUrl');

      await dismissalRepository.updateSingleField(
        studentDocId ,
        dismissalId, 
        {'authorizedPickupImage': uploadImageUrl}
      );
      SLoggerHelper.info('Firestore updated successfully with image URL.');

      dismissal.value.authorizedPickupImage = uploadImageUrl;
      dismissal.refresh();

      imageUploading.value = false;

      // SLoaders.successSnackBar(
      // title: 'Upload Successful',
      // message: 'Image has been successfully uploaded and saved.',
      // );
    } catch (e) {
      SLoggerHelper.error('Error uploading picture: $e');
      SLoaders.errorSnackBar(title: 'Error', message: 'Failed to upload picture: $e');
    } finally {
      imageUploading.value = false;
    }
  }


  // Send Alert Dismissal to Teacher
  alertDismissal(String studentId) async{
    try {
      isLoading.value = true;
      

      final newDismissal = DismissalModel(
        id: AuthenticationRepository.instance.getUserId,
        studentName: studentController.studentParent.value!.name,
        parentName: userController.user.value.fullName,
        studentClass: studentController.studentParent.value!.grade!.name,
        status: 'Calling',
        requestTime: DateTime.now(),

      );

      SLoggerHelper.info('Creating alert for $studentId by ${newDismissal.id}');
      SLoggerHelper.info('Alert Dismissal: $newDismissal');

      await dismissalRepository.createAlertDismissal(studentId, newDismissal.id, newDismissal);

      dismissal.refresh();

      isLoading.value = false;

    } catch (e) {
      SLoggerHelper.error('Error sending alert: $e');
    } finally {
      isLoading.value = false;
    }
  }

  listAlertDismissal(List<String> studentIds) async{
    try {
      isLoading.value = true;

      for(String studentId in studentIds){
        // fetch stundent data for each ID
        final student = studentController.studentParentList.firstWhere((s) => s.docId == studentId);

        final newAlertDismissal = DismissalModel(
          id: AuthenticationRepository.instance.getUserId,
          studentName: student.name,
          parentName: userController.user.value.fullName,
          studentClass: student.grade!.name,
          status: 'Calling', 
          requestTime: DateTime.now(),
        );

        SLoggerHelper.info('Creating alert for $studentId by ${newAlertDismissal.id}');
        await dismissalRepository.createAlertDismissal(studentId, newAlertDismissal.id, newAlertDismissal);
      }
      dismissal.refresh();
      isLoading.value = false;
    } catch (e) {
      SLoggerHelper.error('Error sending alert: $e');
    } finally {
      isLoading.value = false;
    }
  }

}