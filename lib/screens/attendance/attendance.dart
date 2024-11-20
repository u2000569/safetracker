import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/components/bot_navigation.dart';
import 'package:safetracker/core/configs/theme/app_colors.dart';
import 'package:safetracker/screens/attendance/check_in.dart';
import 'package:safetracker/services/database_services.dart';
import 'package:safetracker/services/nfc_services.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);
  late NfcService _nfcService;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _nfcService = NfcService(_databaseService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNav(role: 'Teacher')));
        },),
        
        centerTitle: true,
        title: const Text('Attendance',
        style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(9, 31, 91, 1),
      ),
      backgroundColor: const Color(0xFFE8F1FB), // Background color similar to the image
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Student List Card
            Container(
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
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0B1F5D), // Dark blue color for the icon background
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: const Icon(
                      Icons.school, // Use a suitable icon
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Student List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Check In Button
            Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckIn(),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  backgroundColor: AppColors.primary, // Blue color for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Check In",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Check Out Button
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // Handle check-out action
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  side: const BorderSide(color: Color(0xFF4285F4)), // Border color for the outline button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Check Out",
                  style: TextStyle(fontSize: 16, color: Color(0xFF4285F4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _readNfc() async {
  //   try {
  //     await _nfcService.readNfc();
  //   } catch (e) {
  //     _logger.i('Error reading NFC: $e');
  //   }

    
  // }
}
