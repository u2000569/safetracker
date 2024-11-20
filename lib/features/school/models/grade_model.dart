import 'package:cloud_firestore/cloud_firestore.dart';

class GradeModel{
  String id;
  String name;
  String image;
  int? studentsCount;

  // Not Mapped
  // List<CategoryModel>? gradeCategories;

  GradeModel({
    required this.id,
    required this.image,
    required this.name,
    this.studentsCount,
    // this.gradeCategories,
  });

  /// Empty Helper Function
  static GradeModel empty() => GradeModel(id: '', image: '', name: '');

  /// Convert model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'StudentsCount': studentsCount = 0,
      // 'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory GradeModel.fromJson(Map<String, dynamic> document){
    final data = document;
    if(data.isEmpty) return GradeModel.empty();
    return GradeModel(
      id: data['Id'] ?? '', 
      image: data['Image'] ?? '', 
      name: data['Name'] ?? '',
      studentsCount: int.parse((data['StudentsCount'] ?? 0).toString()),
    );
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory GradeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON Record to the model
      return GradeModel(
        id: document.id, 
        image: data['Image'] ?? '', 
        name: data['Name'] ?? '',
        studentsCount: data['StudentsCount'] ?? '',
      );
    } else{
      return GradeModel.empty();
    }
  }
}