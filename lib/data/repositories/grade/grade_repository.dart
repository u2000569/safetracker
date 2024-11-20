import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/school/models/grade_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class GradeRepository extends GetxController {
  // Singleton instance of the GradeRepository
  static GradeRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all grade from the 'Grade' collection
  Future<List<GradeModel>> getAllGrade() async{
    try {
      final snapshot = await _db.collection("Grade").get(const GetOptions(source: Source.server));
      final result = snapshot.docs.map((e) => GradeModel.fromSnapshot(e)).toList();
      return result;
    }on FirebaseException catch (e) {
      print('FirebaseException in getAllGrade: ${e.message}');
      throw e.message!;
    } on SocketException catch (e){
      print('SocketException in getAllGrade: ${e.message}');
      throw e.message;
    } on PlatformException catch(e){
      print('PlatformException error in getAllGrade: $e');
      throw e.message!;
    }catch (e) {
      throw 'Unexpected error in getAllGrade.';
    }
  }

  // Get all grade categories from the 'GradeCategory' collection
  // Future<List<GradeCategoryModel>> getAllGradeCategories() async{
  //   try {
  //     final gradeCategoryQuery = await _db.collection('GradeCategory').get();
  //     final gradeCategories = gradeCategoryQuery.docs.map((doc) => GradeCategoryModel.fromSnapshot(doc)).toList();
  //     return gradeCategories;
  //   } on FirebaseException catch (e){
  //     throw e.message!;
  //   } on SocketException catch (e){
  //     throw e.message;
  //   } on PlatformException catch (e){
  //     throw e.message!;
  //   }catch (e) {
  //     throw 'Something Went Wrong! Please try again.';
  //   }
  // }

  // Get specific grade categories for a given grade Id @ gradeName
  // Future<List<GradeCategoryModel>> getCategoriesOfSpecificGrade(String gradeId) async {
  //   try {
  //     final gradeCategoryQuery = await _db.collection('GradeCategory').where('gradeId', isEqualTo: gradeId).get();
  //     final gradeCategories = gradeCategoryQuery.docs.map((doc) => GradeCategoryModel.fromSnapshot(doc)).toList();
  //     return gradeCategories;
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } on SocketException catch (e) {
  //     throw e.message;
  //   } on PlatformException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     throw 'Something Went Wrong! Please try again.';
  //   }
  // }

  // Create a new grade document in the 'Grade' collection
  Future<String> creategrade(GradeModel grade) async {
    try {
      final result = await _db.collection("Grade").add(grade.toJson());
      return result.id;
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

  // Create a new grade category document in the 'gradeCategory' collection
  // Future<String> createGradeCategory(GradeCategoryModel gradeCategory) async {
  //   try {
  //     final result = await _db.collection("GradeCategory").add(gradeCategory.toJson());
  //     return result.id;
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

  // Update an existing grade document in the 'Grades' collection
  Future<void> updateGrade(GradeModel grade) async {
    try {
      await _db.collection("Grade").doc(grade.id).update(grade.toJson());
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

  // Delete an existing grade document and its associated grade categories
  Future<void> deleteGrade(GradeModel grade) async {
    try {
      await _db.runTransaction((transaction) async {
        final gradeRef = _db.collection("Grade").doc(grade.id);
        final gradeSnap = await transaction.get(gradeRef);

        if (!gradeSnap.exists) {
          throw Exception("Grade not found");
        }

        final gradeCategoriesSnapshot = await _db.collection('GradeCategory').where('gradeId', isEqualTo: grade.id).get();
        // final gradeCategories = gradeCategoriesSnapshot.docs.map((e) => GradeCategoryModel.fromSnapshot(e));

        // if (gradeCategories.isNotEmpty) {
        //   for (var gradeCategory in gradeCategories) {
        //     transaction.delete(_db.collection('GradeCategory').doc(gradeCategory.id));
        //   }
        // }

        transaction.delete(gradeRef);
      });
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

  // Delete a grade category document in the 'GradeCategory' collection
  Future<void> deleteGradeCategory(String gradeCategoryId) async {
    try {
      await _db.collection("GradeCategory").doc(gradeCategoryId).delete();
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