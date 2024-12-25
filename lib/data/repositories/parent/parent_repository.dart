import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/auth_repository.dart';

class ParentRepository extends GetxController {
  static ParentRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to fetch teacher details based on teacher ID
  Future<List<UserModel>> getParent() async{
    try {
      final parentSnapshot = await _db.collection('Parent').get();
      return parentSnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong to fetch Parent Info: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to fetch teacher details based on user id
  Future<UserModel> fetchParentDetails() async{
    try {
      //await _db.clearPersistence();
      final userId = AuthenticationRepository.instance.getUserId;
      SLoggerHelper.debug('Fetching user details for user ID: $userId');
      final documentSnapshot = await _db.collection('Parent').doc(userId).get();
      if(documentSnapshot.exists){
        SLoggerHelper.debug('Document data: ${documentSnapshot.data()}');
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        SLoggerHelper.debug('Document Parent not found');
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

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Parent").doc(AuthenticationRepository.instance.getUserId).update(json);
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