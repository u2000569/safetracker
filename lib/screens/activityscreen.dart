import 'package:flutter/material.dart';
import 'package:safetracker/screens/attendance/attendance.dart';
//import 'nfcscreen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Activity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(9, 31, 91, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Attendance()),
                      );
                    },
                    child: const ActivityBox(
                      activityName: 'Attendance',
                      icon: Icons.check_circle,
                    ),
                  ),
                  const ActivityBox(activityName: 'Emergency', icon: Icons.warning),
                  const ActivityBox(activityName: 'Hall Pass', icon: Icons.access_time),
                  const ActivityBox(activityName: 'Car', icon: Icons.directions_car),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            // CustomTextField(),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Handle button press
            //   },
            //   child: const Text('Report Emergency'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            //   ),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ActivityBox extends StatelessWidget {
  final String activityName;
  final IconData icon;

  const ActivityBox({super.key, required this.activityName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              activityName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Enter your message',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class ActivityDetailScreen extends StatelessWidget {
  final String activityName;

  const ActivityDetailScreen({super.key, required this.activityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activityName),
      ),
      body: Center(
        child: Text(
          'Details for $activityName',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
