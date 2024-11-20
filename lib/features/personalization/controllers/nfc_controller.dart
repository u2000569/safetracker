import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../data/repositories/parent/parent_repository.dart';
import '../../../data/repositories/teacher/teacher_repository.dart';

class NfcController extends GetxController {
  static NfcController get instance => Get.find();

  final parentRepository = Get.put(ParentRepository());
  final teacherRepository = Get.put(TeacherRepository());
  final studentRepository = Get.put(StudentRepository());

  final RxBool isScanning = false.obs;

  // Function to scan NFC
  Future<void> scanCard(String action) async{
    try {
      isScanning.value = true;

      //check NFC availability
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        throw Exception('NFC is not available on this device');
      }

      //start scanning
      var tag = await FlutterNfcKit.poll(
        iosAlertMessage: 'Scan your card',
        iosMultipleTagMessage: 'Multiple tags found!',
      );
      SLoggerHelper.info('Tag: $tag');

      // Parse NFC data (assuming matric number is stored as text)
      if (tag.ndefAvailable == true) {
        var records = await FlutterNfcKit.readNDEFRecords();
        if(records.isNotEmpty && records.first.payload != null){
          var payload = records.first.payload!;
          int languageCodeLength = payload[0];
          String matricNumber = String.fromCharCodes(
            payload.sublist(languageCodeLength + 1),
          );

          // Update Attendance
          SLoggerHelper.info('Matric Number: $matricNumber');
          SLoggerHelper.info('Action: $action');
          if(action == 'check in'){
            await _checkIn(matricNumber);
            SLoggerHelper.info('Check in successful');
          } else if(action == 'check out'){
            await _checkOut(matricNumber);
          } 
        }else{
            throw Exception('Invalid action');
          }
      }
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally{
      isScanning.value = false;
      await FlutterNfcKit.finish();
    }
  }

  // Function to check-in student
  Future<void> _checkIn(String studentId) async{
    try {
      var student = await studentRepository.fetchStudentId(studentId);
      if(student == null){
        throw Exception('Student not found');
      }


      // Update student attendance status
      await studentRepository.updateStudentAttendance(
        studentId,
        status: 'StudentStatus.present',
        timestamp: DateTime.now(),
      );

      SLoaders.successSnackBar(title: 'Success', message: 'Student ${student.name} checked in successfully');
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Function to check-out student
  Future<void> _checkOut(String studentId) async{
    try {
      var student = await studentRepository.fetchStudentId(studentId);
      if(student == null){
        throw Exception('Student not found');
      }


      // Update student attendance status
      await studentRepository.updateStudentAttendance(
        studentId,
        status: 'StudentStatus.pending',
        timestamp: DateTime.now(),
      );

      SLoaders.successSnackBar(title: 'Success', message: 'Student ${student.name} checked out successfully');
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Function to read data from NFC
  Future<void> readData() async {
    // Implement your NFC read logic here
    // Return the read data as a string
    try {
      // Start Loading
      SLoaders.customToast(message: 'Scan the card to read data');
    } catch (e) {
      
    }
  }

  // Function to write data to NFC
  Future<void> writeData(String data) async {
    // Implement your NFC write logic here
    // Write the provided data to NFC
  }
}