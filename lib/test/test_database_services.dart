import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/model/studentmodel.dart';

class DatabaseService {
  final String? uid;
  final Logger _logger = Logger();

  DatabaseService({this.uid});

  //collectionn reference
  final CollectionReference userCollection = 
  FirebaseFirestore.instance.collection('Users');
  final CollectionReference attendanceCollection =
  FirebaseFirestore.instance.collection('Attendance');
  
  Future<DocumentSnapshot<Object?>>? getNewUserDataSnapshot(User? user) {
    if (user == null) return null;
    return userCollection.doc(user.uid).get();
  }

  //new user register 
  //create new document in cloud firestore 
   Future updateUserData(
    String fullname, 
    String phoneNumber, 
    String email, 
    String role 
    )async{
    await userCollection.doc(uid).set({
      'uid' : uid,
      'fullName': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'role' : role,
      'status': 'pending',
    }).then((_){
      print("Success!");
    });
  }

  //create new collection for attendance
  Future attendaceData(
    String studentId,
  )async{
    await attendanceCollection.doc().set({
      'studentId': studentId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> buildStudentData()async{
    await userCollection
    .doc(uid)
    .collection('StudentInfo')
    .doc('studentId')
    .set({
      'studentName': 'studentName',
      'studentId': 'studentId',
      'studentAddress': 'studentAddress',
      'studentClass': 'studentClass',
    });
  }

  Future<void> buildUserLog() async {
    ///From Log Collection
    await userCollection.doc(uid).collection('log').doc('Activity').set({
      "lastLoginIn": Timestamp.now(),
      "login": [false, false, false, false, false, false, false],
    });

    ///To Log Collection
  }

  List<StudentModel>? _studentList(QuerySnapshot snapshot){
    _logger.i('ListStudentModel');
    return snapshot.docs.map((doc){
      return StudentModel(
        studentId: doc['studentId'], 
        studentName: doc['studentName'], 
        studentAddress: doc['studentAddress'], 
        studentClass: doc['studentClass']
        );
    }).toList();
  }

  Stream<List<StudentModel>?> getStudentList(String studentdatamap){
    _logger.i('StreamStudentModel'); 
    return userCollection
    .doc(uid)
    .collection('StudentData')
    .doc(studentdatamap)
    .collection('studentOverview')
    .snapshots()
    .map(_studentList);
  }


}