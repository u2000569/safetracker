import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../features/school/models/student_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';


class StudentRepository extends GetxController {
  static StudentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  /*--------------------------------- FUCNTIONS ---------------------------------*/

  // Get all students from the 'Student' collection
  // Get all students related to the current user
  Future<List<StudentModel>> getAllStudents() async{
    try {
      final result = await _db.collection('Students').orderBy('attendanceDate', descending: true).get(const GetOptions(source: Source.server));
      return result.docs.map((documentSnaphot) => StudentModel.fromSnapshot(documentSnaphot)).toList();
    } on FirebaseException catch(e){
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      await _db.collection("Students").doc(studentId).delete();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get limited featured students
  Future<List<StudentModel>> getFeaturedStudents() async{
    try {
      final snapshot = await _db.collection('Students').get();
      // Debugging output
    // if (snapshot.docs.isEmpty) {
    //   print("No students found in the collection.");
    // } else {
    //   print("Fetched ${snapshot.docs.length} students.");
    // }
      // final snapshot = await _db.collection('Students').where('IsFeatured', isEqualTo: true).limit(5).get();
      return snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get students based on grade
  Future<List<StudentModel>> fetchStudentByQuery(Query query) async{
    try {
      final querySnapshot = await query.get();
      final List<StudentModel> studentList = querySnapshot.docs.map((doc) => StudentModel.fromQuerySnapshot(doc)).toList();
      return studentList;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// fetch students for a specific grade
  Future<List<StudentModel>> getStudentsForGrade(String gradeId, int limit)async{
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = limit == -1
          ? await _db.collection('Students').where('Grade.Name', isEqualTo:  gradeId).get()
          : await _db.collection('Students').where('Grade.Name', isEqualTo:  gradeId).limit(limit).get();

      // Map Students
      final students = querySnapshot.docs.map((doc) => StudentModel.fromSnapshot(doc)).toList();
      return students;

    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// filter students for a specific grade
  Future<List<StudentModel>> searchStudents(String query, {String? gradeName}) async{
    try {
      //Reference to the collection
      CollectionReference studentsCollection = FirebaseFirestore.instance.collection('Students');

      // Start with basic query
      Query queryRef = studentsCollection;

      if (query.isNotEmpty) {
        queryRef = queryRef.where('Name', isGreaterThanOrEqualTo: query).where('Name', isLessThanOrEqualTo: '$query\uf8ff');
      }

      // Apply filter
      if(gradeName != null){
        queryRef = queryRef.where('Grade.Name', isEqualTo: gradeName);
      }

      // Execute the query
      QuerySnapshot querySnapshot = await queryRef.get();

      // Map Students to StudentModel objects
      final students = querySnapshot.docs.map((doc) => StudentModel.fromQuerySnapshot(doc)).toList();

      return students;

    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Future<void> updateSingleField(String docId, Map<String, dynamic> json) async{
  //   try {
  //     await _db.collection('Students').doc(docId).update(json);
  //   } on FirebaseException catch (e) {
  //     throw SFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const SFormatException();
  //   } on PlatformException catch (e) {
  //     throw SPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  // Update student status
  Future<void> updateStudentStatus(String studentId, Map<String, dynamic> data) async{
    try {
      await _db.collection('Students').doc(studentId).update(data);
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(String studentId, Map<String, dynamic> json) async {
    try {
      if(studentId.isEmpty || json.isEmpty){
        SLoggerHelper.warning('Invalid input: Document ID or JSON data is empty');
      }
      await _db.collection("Students").doc(studentId).update(json);
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateStudentAttendance(String studentId,{
    required String status,
    required DateTime timestamp,
  }) async{
    try {
      final studentDoc = await _db.collection('Students').where('id' , isEqualTo: studentId).get();

      if(studentDoc.docs.isEmpty){
        throw 'Student not found';
      }

      final studentIds = studentDoc.docs.first.id;
      SLoggerHelper.info('Student Id: $studentIds');

      //Update
      await _db.collection('Students').doc(studentIds).update({
        'status': status,
        'attendanceDate': timestamp,
      });
    } catch (e) {
      throw Exception('Error updating student attendance : $e');
    }
  }

  //fetch student by id
  Future<StudentModel?> fetchStudentId(String studentId) async{
    try {
      final studentDoc = await _db.collection('Students').where('id', isEqualTo: studentId).get();

      if(studentDoc.docs.isEmpty){
        return null;
      }

      return StudentModel.fromSnapshot(studentDoc.docs.first);

    } catch (e) {
      SLoggerHelper.error('Error fetching student by id: $e');
      return null;
    }
  }

  // fetch studentparent
  Future<StudentModel?> fetchStudentParent(String parentEmail) async{
    try{
      final studentDoc = await _db.collection('Students').where('Parent.Email', isEqualTo: parentEmail).get();
      
      if(studentDoc.docs.isEmpty){
        SLoggerHelper.warning('Student Parent not found : $parentEmail');
        return null;
      }
      SLoggerHelper.info('Student Parent Data: ${studentDoc.docs.first.data()}');
      return StudentModel.fromSnapshot(studentDoc.docs.first);

    } catch (e){
      SLoggerHelper.error('Error fetching student parent: $e');
      return null;
    }
  }

  ///Upload student profile picture
  Future<String> uploadImage(String path, XFile image) async{
    try {
      final ref = _firebaseStorage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;  
    } catch (e) {
      SLoggerHelper.error('Something went wrong. Please try again');
      throw 'Something went wrong to upload student profile. Please try again';
    }
  }

  // Update student info
  Future<void> updateStudent(StudentModel student) async{
    try {
      await _db.collection('Students').doc(student.docId).update(student.toJson());
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}