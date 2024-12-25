import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/features/personalization/models/user_model.dart';
import 'package:safetracker/utils/exceptions/platform_exceptions.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  


  /// Function to save user data to firestore
  Future<void> saveUserRecord(UserModel user) async{
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
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

  Future<UserModel> fetchUserRole() async{
    try {
      final userId = AuthenticationRepository.instance.getUserId;
      final userDoc = await _db.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        SLoggerHelper.debug('User Document found: ${userDoc.data()?['Role']}');
        return UserModel.fromSnapshot(userDoc);
        // SLoggerHelper.debug('User Role: ${userDoc.data()?['Role']}');
      }else{
        SLoggerHelper.debug('User Document not found');
        return UserModel.empty();
      }
    }on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SFormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later';
    }
  }

  /// Function to fetch teacher details based on user id
  Future<UserModel> fetchTeacherDetails() async{
    try {
      //await _db.clearPersistence();
      final userId = AuthenticationRepository.instance.getUserId;
      print('Fetching user details for user ID: $userId');

      final documentSnapshot = await _db.collection('Teacher').doc(userId).get();
      if(documentSnapshot.exists){
        print('Document data: ${documentSnapshot.data()}');
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        print('collection not found');
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

  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
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
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(AuthenticationRepository.instance.getUserId).update(json);
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

   /// Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
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
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to remove user data from Firestore.
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
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

  // Save the current user's OneSignal Id
  Future<void> saveOneSignalId() async{
    try {
      // get the current user's UID firestore document
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) return;

      // get the current device's OneSignal Id
      final oneSignalId = await OneSignal.User.getOnesignalId();

      if(oneSignalId != null){
        // save the OneSignal Id to the user's document
        await _db.collection('Users').doc(user.uid).update({
          'OneSignalId': oneSignalId
        });
        SLoggerHelper.info('OneSignal Id saved : $oneSignalId');
      } else{
        SLoggerHelper.error('OneSignal Id not found');
      }
    } catch (e) {
      SLoggerHelper.error('Error Saving OneSignal Id: $e');
    }
  }

  // Set External ID for OneSignal
  Future<void> setExternalId(String externalId) async{
    try {
      await OneSignal.User.addAlias(externalId, externalId);
      SLoggerHelper.info("External Id set: $externalId");
    } catch (e) {
      SLoggerHelper.error("Error setting External Id: $e");
    }
  }

  // fetch the onesignal id (OneSignalId) of a user
  Future<String?> fetchOneSignalId() async{
    try {
      final userId = AuthenticationRepository.instance.getUserId;
      SLoggerHelper.info('userId: $userId');

      final userDoc = await _db.collection('Users').doc(userId).get();
      SLoggerHelper.info('User Document: ${userDoc.data()}');
      if (userDoc.exists) {
        final oneSignalId = userDoc.data()?['OneSignalId'] as String?;
        if(oneSignalId != null && oneSignalId.isNotEmpty){
          SLoggerHelper.info('OneSignal Id found: $oneSignalId');
          return oneSignalId;
        }else{
          SLoggerHelper.warning('OneSignal Id not found for user: $userId');
          return null;
        }
      } else{
        SLoggerHelper.warning('User Document not found for user: $userId');
        return null;
      }
    } catch (e) {
      SLoggerHelper.error('Error fetching OneSignal Id: $e');
      return null;
    }
  }
}