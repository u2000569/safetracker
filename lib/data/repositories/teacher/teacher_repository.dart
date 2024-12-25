import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:safetracker/data/repositories/user/user_repository.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/auth_repository.dart';

class TeacherRepository extends GetxController {
  static TeacherRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to fetch teacher details based on teacher ID
  Future<List<UserModel>> getTeacher() async{
    try {
      final teacherSnapshot = await _db.collection('Teacher').get();
      return teacherSnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong to fetch Teacher Info: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to fetch teacher details based on user id
  Future<UserModel> fetchTeacherDetails() async{
    try {
      //await _db.clearPersistence();
      final userId = AuthenticationRepository.instance.getUserId;
      SLoggerHelper.debug('Fetching user details for user ID: $userId');

      final documentSnapshot = await _db.collection('Teacher').doc(userId).get();
      if(documentSnapshot.exists){
        String? role = documentSnapshot.get('Role');
        SLoggerHelper.debug('Set a Tag for Role: $role');
        if(role != null){
          // Set the tag in OneSignal
          OneSignal.User.addTagWithKey("Role", role);
        }else{
          SLoggerHelper.warning("Role field is missing: $role");
        }
        SLoggerHelper.debug('Document data: ${documentSnapshot.data()}');
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        SLoggerHelper.debug('Document Teacher not found');
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later';
    }
  }
}