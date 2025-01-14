import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:safetracker/features/school/models/attendance_model.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';
class AttendanceRepository extends GetxController {
  static AttendanceRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /*----------------------Save Attendance Student----------------------*/
  Future<void> saveAttendanceStudent(DateTime date, String docIdAttd, String studentName, AttendanceModel attendance) async{
    try {
      // Create a new DateTime instance with only year, month, and day
      // final formattedDate = DateTime(date.year, date.month, date.day);
      // final dateKey = formattedDate.toIso8601String().split('T').first;

      final dateKey = _formatDate(date);

      // Ensure the parent document exists with a dummy field
      final parentDocRef = _db.collection('Attendance').doc(dateKey);
      final parentDocSnapshot = await parentDocRef.get();

      if (!parentDocSnapshot.exists) {
        // Add a dummy field to the parent document
        await parentDocRef.set({'placeholder': true});
      }

      // Reference to the student document
      final studentDocRef = parentDocRef.collection('studentsRecords').doc(docIdAttd);

      // check if document already exists
      final studentDocSnapshot = await studentDocRef.get();
      if(studentDocSnapshot.exists){
        SLoaders.warningSnackBar(title: 'Already checked in', message: 'Student $studentName has already checked in.');
        SLoggerHelper.error('Student DocID $docIdAttd already exists');
        throw Exception('Student DocID $docIdAttd already exists');
      } else{
        await studentDocRef.set(attendance.toJson());
      }


      /*------- optional 2: save attendance to the parent document -------*/
      // await parentDocRef.collection('studentsRecords')
      // .doc(docIdAttd).set(attendance.toJson());

      /*------- optional 1: save attendance to the parent document -------*/
      // await _db.collection('Attendance').doc(dateKey)
      //   .collection('studentsRecords').doc(docIdAttd)
      //   .set(attendance.toJson());
      SLoggerHelper.info('Attendance on $dateKey for $docIdAttd saved successfully');
    } catch (e) {
      SLoggerHelper.error('Error saving attendance: $e');
    }
  }

  /*----------------------Update Attendance Student----------------------*/
  Future<void> updateAttendanceStudent(DateTime date, String docIdAttd, String studentName, Map<String, dynamic> json) async{
    try {
      // Create a new DateTime instance with only year, month, and day
      // final formattedDate = DateTime(date.year, date.month, date.day);
      // final dateKey = formattedDate.toIso8601String().split('T').first;

      final dateKey = _formatDate(date);

      // Reference to the student document
      final studentDocRef = _db
          .collection('Attendance')
          .doc(dateKey)
          .collection('studentsRecords')
          .doc(docIdAttd);
      
      // Check if the student document exists
      final studentDocSnapshot = await studentDocRef.get();
      if (!studentDocSnapshot.exists) {
        SLoaders.warningSnackBar(title: 'No record attendance', message: 'Attendance record for student $studentName on $dateKey does not exist.');
        throw Exception('Attendance record for student $docIdAttd on $dateKey does not exist.');
      }

      // Fetch existing data
      final existingData = studentDocSnapshot.data();
      if (existingData == null) {
        throw Exception('No data found for student $docIdAttd on $dateKey.');
      }

      // Check if `checkIn` exists before allowing `checkOut` update
      if (json.containsKey('checkOut')) {
        if (existingData['checkIn'] == null) {
          SLoaders.warningSnackBar(title: 'Need to check in first', message: 'Student $studentName has not checked in yet.');
          throw Exception('Cannot update checkOut. Student $docIdAttd has not checked in yet.');
        }
      }

      // Check if `checkIn` is being updated and already exists
      if (json.containsKey('checkIn') && existingData['checkIn'] != null) {
        throw Exception('Cannot update checkIn. Student $docIdAttd has already checked in.');
      }

      await studentDocRef.update(json);

      // await _db.collection('Attendance').doc(dateKey)
      //     .collection('studentsRecords').doc(docIdAttd)
      //     .update(json);
      SLoggerHelper.info('Attendance on $dateKey updated successfully');
    } catch (e) {
      SLoggerHelper.error('Error updating attendance: $e');
    }
  }

  /*----------------------Get All Attendance Records----------------------*/
  Future<List<AttendanceModel>> getAllAttendanceRecords() async {
    List<AttendanceModel> allRecords = [];
    try {
      final dateDocs = await _db.collection('Attendance').get();

      for (var dateDoc in dateDocs.docs) {
        final studentRecords = await _db.collection('Attendance')
            .doc(dateDoc.id)
            .collection('studentsRecords')
            .get();

        allRecords.addAll(studentRecords.docs.map((doc) {
          return AttendanceModel.fromMap(doc.data());
        }));
      }
      return allRecords;
    } catch (e) {
      SLoggerHelper.error('Error retrieving all attendance records: $e');
      return [];
    }
  }

  /*----------------------Get Attendance for Specific Date----------------------*/
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    try {
      final dateKey = _formatDate(date);

      final querySnapshot = await _db.collection('Attendance')
          .doc(dateKey)
          .collection('studentsRecords')
          .get();

      return querySnapshot.docs.map((doc) {
        return AttendanceModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      SLoggerHelper.error('Error retrieving attendance for date $date: $e');
      return [];
    }
  }

  /*----------------------Get Specific Student Attendance Record----------------------*/
  Future<List<AttendanceModel>> getAttendanceForStudent(String studentId) async {
    try {
      final querySnapshot = await _db.collectionGroup('studentsRecords')
          .where(FieldPath.documentId, isEqualTo: studentId)
          .get();

      return querySnapshot.docs.map((doc) {
        return AttendanceModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      SLoggerHelper.error('Error retrieving attendance for student $studentId: $e');
      return [];
    }
  }

  /*----------------------Helper Function to Format Date----------------------*/
  String _formatDate(DateTime date) {
    return DateTime(date.year, date.month, date.day)
        .toIso8601String()
        .split('T')
        .first;
  }
}