import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
// import 'package:safetracker/data/abstract/base_data_table_controller.dart';
import 'package:safetracker/data/repositories/attendance/attendance_repository.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/models/attendance_model.dart';
import 'package:safetracker/features/school/models/student_model.dart';
// import 'package:safetracker/features/school/screens/activity/attendance/attendance_screen.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';

import '../../../data/repositories/parent/parent_repository.dart';
import '../../../data/repositories/teacher/teacher_repository.dart';
import '../../../utils/constants/enums.dart';

class NfcController extends GetxController {
  static NfcController get instance => Get.find();

  final parentRepository = Get.put(ParentRepository());
  final teacherRepository = Get.put(TeacherRepository());
  final studentRepository = Get.put(StudentRepository());
  final attendanceRepository = Get.put(AttendanceRepository());

  final studentList = StudentController.instance;

  final RxBool isScanning = false.obs;

  // Function to scan NFC
  Future<void> scanCard(String action) async{
    try {
      isScanning.value = true;

      // Update List Getx
      

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

          // find student in list 
          var index = studentList.filteredItems.indexWhere((element) => element.id == matricNumber);
          if(index == -1){
            throw Exception('Student not found in the list ${studentList.filteredItems}');
          }

          final studentDataList = studentList.filteredItems[index];
          SLoggerHelper.info('Student Data List: ${studentDataList.name}');

          final checkTime = DateTime.now();
            final formattedCheckTime = DateTime(
              checkTime.year, 
              checkTime.month, 
              checkTime.day, 
              checkTime.hour, 
              checkTime.minute,
            );

          if(action == 'check in'){

            // AttendanceModel studentAttendance; 
            final attendance = AttendanceModel(
              docIdAttd: studentDataList.docId,
              studentId: studentDataList.id, 
              studentName: studentDataList.name, 
              studentGrade: studentDataList.grade!.name,
              checkIn: formattedCheckTime,
            );
            SLoggerHelper.info('Check in data: ${attendance.checkIn}');
            attendanceRepository.saveAttendanceStudent(attendance.checkIn!, attendance.docIdAttd, attendance.studentName, attendance);

            // await _checkIn(matricNumber);
            await _checkInStudent(studentDataList, index);
            // await FirebaseFirestore.instance.collection('Attendance').doc(studentDataList.docId).set(attendance.toJson());
            SLoggerHelper.info('Check in successful');
          } else if(action == 'check out'){

            // AttendanceModel studentAttendance;
            final attendance = AttendanceModel(
              docIdAttd: studentDataList.docId,
              studentId: studentDataList.id, 
              studentName: studentDataList.name, 
              studentGrade: studentDataList.grade!.name,
              checkOut: formattedCheckTime,
            );
            final checkOutData = {'checkOut': formattedCheckTime};
            SLoggerHelper.info('Check Out Data: $checkOutData');
            await attendanceRepository.updateAttendanceStudent(
              attendance.checkOut!, 
              attendance.docIdAttd, 
              attendance.studentName, 
              checkOutData
            );

            await _checkOutStudent(studentDataList,index);
            SLoggerHelper.info('Check out successful');
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

      SLoggerHelper.info('${student.name} : status: ${student.status}');

      // Check if student is already checked in
      if(student.status == StudentStatus.present){
        // show pop up bar or sncakbar indicating the student is already checked in
        SLoaders.warningSnackBar(
          title: 'Already Checked In',
          message: '${student.name} is already checked in.'
        );
        return;
      } else{
        // Map Student Data to Student Model
        final newRecord = StudentModel(
          id: studentId, 
          attendanceDate: DateTime.now(), 
          status: StudentStatus.present, 
        );

        // Update student attendance status
      await studentRepository.updateStudentAttendance(
        studentId,
        status: 'StudentStatus.present',
        timestamp: DateTime.now(),
      );

      SLoggerHelper.info('Student ID: $studentId');

      // Update the table data
      // SBaseController.instance.updateItemFromLists(student);

      StudentController.instance.updateItemFromLists(newRecord);


      SLoggerHelper.info('Student checked in successfully');
      SLoaders.successSnackBar(title: 'Success', message: '${student.name} checked in successfully');
      }


      
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

      if(student.status == StudentStatus.waiting){
        // show pop up bar or sncakbar indicating the student is already checked out
        SLoaders.warningSnackBar(
          title: 'Already Checked Out',
          message: '${student.name} is already checked out.'
        );
        return;
      } else{
        // Update student attendance status
      await studentRepository.updateStudentAttendance(
        studentId,
        status: 'StudentStatus.waiting',
        timestamp: DateTime.now(),
      );

      // Update the table data
      // SBaseController.instance.updateItemFromLists(student);

      SLoaders.successSnackBar(title: 'Success', message: 'Student ${student.name} checked out successfully');
      }
      
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _checkInStudent(StudentModel student, int index) async{
    try {
      SLoggerHelper.info('Student Check In: ${student.toJson()}');
      if (student.status == StudentStatus.present ){
        // SLoaders.warningSnackBar(
        //   title: 'Already Checked In',
        //   message: '${student.name} is already checked in.'
        // );
        return;
      } else{
        student.status = StudentStatus.present;
        student.attendanceDate = DateTime.now();

        // Update student attendance status in firebase
        await studentRepository.updateStudentAttendance(
          student.id,
          status: 'StudentStatus.present',
          timestamp: DateTime.now(),
        );

        // Update student in the list
        StudentController.instance.updateStudentList(student);
        // SLoaders.successSnackBar(title: 'Success', message: '${student.name} checked in successfully');
        update();
        // Get.off(() => AttendanceScreen());
      }
    } catch (e) {
      SLoggerHelper.error('Error checking in student: $e');
    }
  }

  Future<void> _checkOutStudent(StudentModel student, int index) async{
    try {
      SLoggerHelper.info('Student Check Out: ${student.toJson()}');
      if (student.status == StudentStatus.waiting ){
        // SLoaders.warningSnackBar(
        //   title: 'Already Checked Out',
        //   message: '${student.name} is already checked out.'
        // );
        return;
      } else{

        student.status = StudentStatus.waiting;
        student.attendanceDate = DateTime.now();

        // Update student attendance status in firebase
        await studentRepository.updateStudentAttendance(
          student.id,
          status: 'StudentStatus.waiting',
          timestamp: DateTime.now(),
        );

        // Update student status in the list
        StudentController.instance.updateStudentList(student);
        // SLoaders.successSnackBar(title: 'Success', message: '${student.name} checked out successfully');
        update();
        // Get.off(() => AttendanceScreen());
      }
    } catch (e) {
      SLoggerHelper.error('Error checking out student: $e');
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