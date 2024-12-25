import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/features/school/models/emergency_model.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class EmergencyRepository extends GetxController {
  static EmergencyRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  /* --------------------- Get All Emergencies --------------------- */
  Future<List<EmergencyModel>> getAllEmergency() async{
    try {
      final data = await _db.collection('Emergency').orderBy('timestamp', descending: true)
      .get(const GetOptions(source: Source.server));
      SLoggerHelper.info("All Emergency data retrieved ${data.docs}");
      return data.docs.map((doc) => EmergencyModel.fromDocument(doc)).toList();
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

  /* --------------------- Delete Emergency --------------------- */
  Future<void> deleteEmergency(String emergencyId) async{
    try {
      await _db.collection('Emergency').doc(emergencyId).delete();
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

  /* --------------------- Add Emergency --------------------- */
  Future addEmergency(EmergencyModel emergency) async{
    try {
      final doc = await _db.collection('Emergency').add(emergency.toJson());
      return doc.id;
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

  /* --------------------- Upload Image Emergency --------------------- */
  Future<String> uploadEmergencyImage(String path, XFile image) async{
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
      SLoggerHelper.error('Cannot Upload Emergency Image: $e');
      throw 'Something went wrong to upload emergency image. Please try again';
    }
  }
}