import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  String _formattedDate = '';
  String _formattedTime = '';
  late Timer _timer;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _classes = [
    {'name': '7 Honour', 'present': '9', 'total': '12'},
    {'name': '7 Iman', 'present': '12', 'total': '15'},
    {'name': '8 Gratitude ', 'present': '12', 'total': '15'},
    {'name': '8 Scholars', 'present': '12', 'total': '15'},
    {'name': '9 Dignity', 'present': '12', 'total': '15'},
    // Add more classes as needed
  ];

  List<Map<String, String>> _filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _filteredClasses = _classes;
    // Schedule the timer to update the time every minute
    _timer = Timer.periodic(
      const Duration(minutes: 1), 
      (Timer t) => _updateDateTime(),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  void _updateDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat dateFormatter = DateFormat('EEEE, dd MMMM yyyy', 'en_US');
    final DateFormat timeFormatter = DateFormat('HH:mm');

    setState(() {
      _formattedDate = dateFormatter.format(now.toUtc().add(const Duration(hours: 8)));  // Malaysia Time is UTC+8
      _formattedTime = timeFormatter.format(now.toUtc().add(const Duration(hours: 8)));
    });
  }

  void _filterClasses(String query) {
    setState(() {
      _filteredClasses = _classes
          .where((cls) => cls['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FB), // Background color similar to the image
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 38),
            Text(
              ' $_formattedDate',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              ' $_formattedTime',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Good morning!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: _filterClasses,
              decoration: InputDecoration(
                hintText: 'Search class...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            // Horizontal Scrollable List of Class Cards
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filteredClasses.length,
                itemBuilder: (context, index) {
                  final cls = _filteredClasses[index];
                  return _buildClassCard(cls);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, String> cls) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage('assets/images/class.jpg'), // Add a suitable background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cls['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${cls['present']} / ${cls['total']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                cls['name']!, // Repeating the class name
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
