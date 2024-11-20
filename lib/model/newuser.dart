import 'package:cloud_firestore/cloud_firestore.dart';

class NewUser{
  final String? uid;

  NewUser({this.uid});

  get userUid{
    return uid;
  }
}

class NewUserActivityLog{
  final List? activity;
  final Timestamp? lastLoginIn;

  NewUserActivityLog({
    this.lastLoginIn,
    this.activity
    });
}

class NewUserData{
  late final String? uid;
  late String? fullName;
  late final String? phoneNumber;
  late final String? email;
  late final String? role;

  NewUserData({
    this.uid,
    this.fullName,
    this.role,
    this.phoneNumber,
    this.email
  });

  factory NewUserData.fromMap(Map data){
    return NewUserData(
      uid: data['uid'],
      fullName: data['fullName'],
      role: data['role'],
      phoneNumber: data['phoneNumber'],
      //email: data['email']
    );
  }

  void setName(String fullName){
    this.fullName = fullName;
  }

}