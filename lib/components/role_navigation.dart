import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/screens/authentication/usersignin.dart';
import 'package:safetracker/screens/homescreen/teacherhomescreen.dart';

import '../screens/homescreen/parenthomescreen.dart';

final Logger _logger = Logger();

Future<String?> getUserRole(String uid) async{
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  if(userDoc.exists){
    _logger.i('fetch role user');
    return userDoc['role'];
  }
  return null;
}

void navigateRole(BuildContext context, String uid) async{
    String? role = await getUserRole(uid);

    if(role == 'Parent'){
      _logger.i('role parent');
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context)=> const ParentHomeScreen()),
      );
    }else if(role == 'Teacher'){
      _logger.i('role teacher');
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context)=> const TeacherHomeScreen()),
      );
    } else{
      _logger.i('role unkown');
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context)=> const UserSignIn()),
      );
    }
  }