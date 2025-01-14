import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel{
  String docIdAttd;
  String studentId;
  String studentName;
  String studentGrade;
  DateTime? checkIn;
  DateTime? checkOut;

  AttendanceModel({
    this.docIdAttd = '',
    required this.studentId,
    required this.studentName,
    required this.studentGrade,
    this.checkIn,
    this.checkOut,
  });

  // Convert Attendance object to Map for Firebase storage
  Map<String, dynamic> toJson(){
    return{
      'docIdAttd': docIdAttd,
      'studentId': studentId,
      'studentName': studentName,
      'studentGrade': studentGrade,
      'checkIn': checkIn,
      'checkOut': checkOut,
    };
  }

  // Convert Map from Firebase storage to Attendance object
  factory AttendanceModel.fromMap(Map<String, dynamic> map){
    return AttendanceModel(
      docIdAttd: map['docIdAttd'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      studentGrade: map['studentGrade'],
      checkIn: map['checkIn'] != null ? (map['checkIn'] as Timestamp).toDate() : null,
      checkOut: map['checkOut'] != null ? (map['checkOut'] as Timestamp).toDate() : null,
    );
  }




}