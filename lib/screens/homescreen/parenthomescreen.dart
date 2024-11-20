import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/screens/editstudentscreen.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  late User? user;
  late String uid;
  
  final ValueNotifier<String> _formattedDate = ValueNotifier('');
  final ValueNotifier<String> _formattedTime = ValueNotifier('');
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    
    if (user != null) {
      uid = user!.uid;
      _updateDateTime();
      // Schedule the timer to update the time every second
      _timer = Timer.periodic(
        const Duration(seconds: 1), 
        (Timer t) => _updateDateTime(),
      );
    } else {
      // Handle user not logged in
      // Navigate to login screen or show an appropriate message
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
  
  void _updateDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat dateFormatter = DateFormat('EEEE, dd MMMM yyyy', 'en_US');
    final DateFormat timeFormatter = DateFormat('HH:mm');

    _formattedDate.value = dateFormatter.format(now.toUtc().add(const Duration(hours: 8)));  // Malaysia Time is UTC+8
    _formattedTime.value = timeFormatter.format(now.toUtc().add(const Duration(hours: 8)));
  }

  Stream<DocumentSnapshot> _getStudentInfoStream() {
    _logger.i('Read Data on StudentInfo + StudentId');
    return _firestore.collection('Users').doc(uid).collection('StudentInfo').doc('studentId').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FB), // Background color similar to the image
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use ValueListenableBuilder to update date and time without rebuilding the StreamBuilder
            ValueListenableBuilder(
              valueListenable: _formattedDate,
              builder: (context, value, child) {
                return Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: _formattedTime,
              builder: (context, value, child) {
                return Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              "Good morning!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
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
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage('assets/images/kidprofile.jpg'), // Replace with your image asset path
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "IDDRISI School",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['studentName'],
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['studentId'],
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['studentAddress'],
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['studentClass'],
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 30),
                                SizedBox(width: 8),
                                Text(
                                  "Present",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to edit information screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentScreen(uid: uid),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                child: const Text("Edit Information"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
