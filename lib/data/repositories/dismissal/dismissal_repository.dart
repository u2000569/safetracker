import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../features/school/models/dismissal_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class DismissalRepositpory extends GetxController {
  static DismissalRepositpory get instance => Get.find();

  /// Variable
  final _db = FirebaseFirestore.instance;
  final studentsWithDismissals = <Map<String, dynamic>>[].obs;

  /*------------------- Fetch All Dismissals -------------------*/
  Future<List<DismissalModel>> fetchAllDismissals() async{
    try {
      final result = await _db.collection('Students').get();

      // final List<Map<String, dynamic>> fetchedStudents = [];
      final List<DismissalModel> fetchedDismissals = [];

      for(final student in result.docs){
        final dismissalSnapshot = await _db.collection('Students')
        .doc(student.id)
        .collection('DismissalRequest')
        .get();

        SLoggerHelper.info('Student ID: ${student.id}');

        if (dismissalSnapshot.docs.isNotEmpty) {
          for( final dismissalDoc in dismissalSnapshot.docs){
            fetchedDismissals.add((DismissalModel.fromMap(
              dismissalDoc.data(),
              dismissalDoc.id
            )
            // 'student name': student.data()['name'] ?? 'N/A',
            // 'class': student.data()['class'] ?? 'N/A',
            // 'dismissal': dismissalSnapshot.docs.map((e) => e.data()).toList()
          ));
          }
        }
        SLoggerHelper.info('Dismissal Data Collection: ${dismissalSnapshot.docs}');
      }
      return fetchedDismissals;
      // studentsWithDismissals.value = fetchedStudents;
      // return fetchedStudents.map((e) => DismissalModel.fromMap(e)).toList();
      // return result.docs.map((e) => DismissalModel.fromDocument(e)).toList();
    } catch (e) {
      SLoggerHelper.error('Error fetching all dismissals: $e');
      return [];
    }
  }

  /*------------------- Fetch Specific Student's Dismissal -------------------*/
  Future<DismissalModel?> fetchStudentDismissal(String studentId, dismissalId) async{
    try {
      final result = await _db.collection('Students').doc(studentId).collection('DismissalRequest')
      .doc(dismissalId).get();

      if (!result.exists) {
        SLoggerHelper.warning('No Dismissal Document found for $studentId');
        return null;
      }
      SLoggerHelper.info('Dismissal Data Collection: ${result.data()}');

      return DismissalModel.fromDocument(result);
    } catch (e) {
      SLoggerHelper.error('Error fetching student dismissal: $e');
      return null;
    }
  }

  /*------------------- Create Dismissal -------------------*/
  Future<void> createDismissal(DismissalModel dismissal) async{
    try {
      await _db.collection('Dismissal').doc(dismissal.id).set(dismissal.toJson());
      SLoggerHelper.info('Dismissal created successfully');
    } catch (e) {
      SLoggerHelper.error('Error creating dismissal: $e');
    }
  }

  /*------------------- Dismissal authorization -------------------*/
  Future<void> dismissalAuthorization(String dismissalId, bool authStatus) async{
    try {
      await _db.collection('Dismissal').doc(dismissalId).update({'authorized': authStatus});
      SLoggerHelper.info('Dismissal authorization updated successfully : $authStatus');
    } catch (e) {
      SLoggerHelper.error('Error updating dismissal authorization : $e');
    }
  }
  /*------------------- Create Dismissal Request -------------------*/
  Future<void> createrequestDismissal(String studentId, dismissalId, DismissalModel dismissal)async{
    try {
      SLoggerHelper.info('Dismissal Request for $studentId by $dismissalId' );
      await _db.collection('Students').doc(studentId).collection('DismissalRequest')
      .doc(dismissalId).set(dismissal.toJson());
      SLoggerHelper.info('Dismissal Request created successfully');
    } catch (e) {
      SLoggerHelper.error('Error creating dismissal request: $e');
    }
  }

  /*------------------- Create Alert Dismissal Request -------------------*/
  Future<void> createAlertDismissal(String studentId, dismissalId, DismissalModel dismissal)async{
    try {
      SLoggerHelper.info('Dismissal Request for $studentId by $dismissalId' );
      await _db.collection('Students').doc(studentId).collection('AlertDismissalRequest')
      .doc(dismissalId).set(dismissal.toJson());
      SLoggerHelper.info('Alert Dismissal created successfully');
    } catch (e) {
      SLoggerHelper.error('Error creating alert dismissal: $e');
    }
  }

  /*------------------- Dismissal Request -------------------*/
  Future<void> updateRequestDismissal(String studentId, dismissalId, DismissalModel dismissal)async{
    try {
      SLoggerHelper.info('Dismissal Request for $studentId by $dismissalId' );
      await _db.collection('Students').doc(studentId).collection('DismissalRequest')
      .doc(dismissalId).update(dismissal.toJson());
      SLoggerHelper.info('Dismissal Request created successfully');
    } catch (e) {
      SLoggerHelper.error('Error creating dismissal request: $e');
    }
  }

  /*------------------- Dismissal Update Single Field -------------------*/
  Future<void> updateSingleField(String studentId, dismissalId, Map<String,dynamic> json) async{
    try {
      if(dismissalId.isEmpty || json.isEmpty){
        SLoggerHelper.error('Invalid input dismissal: Document ID or JSON data is empty');
      }
      await _db.collection('Students').doc(studentId).collection('DismissalRequest')
      .doc(dismissalId).update(json);
      SLoggerHelper.info('Dismissal updated successfully');
    }on FirebaseException catch (e) {
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