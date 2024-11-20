import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/screens/authentication/usersignin.dart';
import 'editstudentscreen.dart';
import 'homescreen/parenthomescreen.dart';
import 'homescreen/teacherhomescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  late User? user;
  late String uid;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      uid = user!.uid;
      navigateRole(context, user!.uid);
    } else {
      // Handle user not logged in
      // Navigate to login screen or show an appropriate message
    }
  }

  // fetch the user's role when the app start or when needed
  Future<String?> getUserRole(String uid) async{
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (userDoc.exists){
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

  Stream<DocumentSnapshot> _getStudentInfoStream() {
    _logger.i('Read Data on StudentInfo + StudentId');
    return _firestore.collection('Users').doc(uid).collection('StudentInfo').doc('studentId').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:const Text(
          'Student Detail',
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: const Color.fromRGBO(9, 31, 91, 1),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getStudentInfoStream(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${data['studentName']}', style: const TextStyle(fontSize: 18)),
                      Text('Student ID: ${data['studentId']}', style: const TextStyle(fontSize: 18)),
                      Text('Student Address: ${data['studentAddress']}', style: const TextStyle(fontSize: 18)),
                      Text('Student Class: ${data['studentClass']}', style:const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditStudentScreen(uid: uid),
                              ),
                            );
                          },
                          child: const Text('Edit Student Info'),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
