import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safetracker/features/school/models/dismissal_model.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/logging/logger.dart';
import '../../personalization/models/user_model.dart';
import 'grade_model.dart';

class StudentModel{
  final String docId;
  String id;
  final String userId;
  // final double age;
  DateTime attendanceDate;
  StudentStatus status;
  String thumbnail;
  String name; // same as title product
  GradeModel? grade;
  UserModel? parent;
  DismissalModel? dismissal;

  StudentModel({
    required this.id,
    this.docId = '', 
    this.userId = '', 
    required this.attendanceDate,
    required this.status,
    this.thumbnail = '',
    this.name = '',
    this.grade,
    this.parent,
    this.dismissal,
  });

  String get formattedAttendanceDate => SHelperFunctions.getFormattedDate(attendanceDate);

  String get studentStatusText => status == StudentStatus.present
    ? 'Present'
    : status == StudentStatus.absent
      ? 'Student is absent'
      : 'Processing';
  
  /// Static function to create an empty user model
  static StudentModel empty() => StudentModel(
    id: '', 
    attendanceDate: DateTime.now(), 
    status: StudentStatus.pending,
    thumbnail: '',
    name: '',
    );

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'userId': userId,
      'status': status.toString(), // enum to string
      'attendanceDate': attendanceDate,
      'thumbnail': thumbnail,
      'name' : name,
      'Grade': grade?.toJson(),
      'Parent': parent?.toJson(),
      'Dismissal': dismissal?.toJson(),
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory StudentModel.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return StudentModel.empty();
    }
    SLoggerHelper.info("Mapping Firestore document to StudentModel: ${data['name'] ?? ''}");
    return StudentModel(
      docId: snapshot.id,
      id: data.containsKey('id') ? data['id'] as String : '',
      userId: data.containsKey('userId') ? data['userId'] as String : '',  
      attendanceDate: data.containsKey('attendanceDate') ? (data['attendanceDate'] as Timestamp).toDate() : DateTime.now(), 
      status: data.containsKey('status')
      ? StudentStatus.values.firstWhere(
        (e) => e.toString() == data['status'], 
        orElse: () => StudentStatus.pending)
        : StudentStatus.pending,
      thumbnail: data['thumbnail'] ?? '',
      name: data['name'] ?? '',
      grade: data.containsKey('Grade') && data['Grade'] != null ? GradeModel.fromJson(data['Grade']) : null,
      parent: data.containsKey('Parent') && data['Parent'] != null ? UserModel.fromJson(data['Parent']) : null,
      dismissal: data.containsKey('Dismissal') && data['Dismissal'] != null ? DismissalModel.fromDocument(data['Dismissal']) : null,

    );
  }

  /// Map Json oriented document snapshot from Firebase to Model
  /// This is a better approach to avoid null safety issues
  factory StudentModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document){
    final data = document.data() as Map<String, dynamic>;
    return StudentModel(
      id: document.id, 
      attendanceDate: data['attendanceDate'] != null ? (data['attendanceDate'] as Timestamp).toDate() : DateTime.now(), 
      status: data.containsKey('status')
          ? StudentStatus.values.firstWhere(
          (e) => e.toString() == data['status'],
          orElse: () => StudentStatus.pending)
          : StudentStatus.pending,
      thumbnail: data['thumbnail'] ?? '', 
      name: data['name'] ?? '',
      );

    
  }

}