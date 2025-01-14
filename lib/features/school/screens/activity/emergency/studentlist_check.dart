import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/image_strings.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _students = [];
  List<String> _selectedStudents = [];
  bool _isLoading = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot;
      if (_showAll) {
        snapshot = await _firestore.collection('Students').get();
      } else {
        snapshot = await _firestore
            .collection('Students')
            .where('status', isEqualTo: 'StudentStatus.present')
            .get();
      }

      setState(() {
         // Get Grade field
        _students = snapshot.docs.map((doc){
          final data = doc.data() as Map<String, dynamic>;
          final grade = data['Grade'] as Map<String, dynamic>?;
          return{
            'id': doc.id,
            'status': data['status'],
            'name': data['name'],
            'thumbnail': data['thumbnail'],
            'Grade': grade?['Name'] ?? 'Unknown',
            // ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleStudentSelection(String studentId) {
    setState(() {
      if (_selectedStudents.contains(studentId)) {
        _selectedStudents.remove(studentId);
      } else {
        _selectedStudents.add(studentId);
      }
    });
  }

  Future<void> _submitReport() async {
    if (_selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No students selected!')),
      );
      return;
    }

    try {
      await _firestore.collection('Reports').add({
        'timestamp': FieldValue.serverTimestamp(),
        'students': _selectedStudents,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );

      // Clear the selection
      setState(() {
        _selectedStudents.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List Emergency Check'),
        // actions: [
        //   Switch(
        //     value: _showAll, 
        //     onChanged: (value){
        //       setState(() {
        //         _showAll = value;
        //       });
        //       _fetchStudents();
        //     },
        //   ),
        //   const SizedBox(width: 10),
        // ],
        backgroundColor: SColors.warning,
      ),
      body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _showAll = false;
                          _fetchStudents();
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: _showAll ? SColors.warning : SColors.darkGrey,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'Present Students', 
                        style: TextStyle(color: SColors.white),
                      )
                    ),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _showAll = true;
                          _fetchStudents();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showAll ? SColors.warning : SColors.darkGrey,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'All Students',
                        style: TextStyle(color: SColors.white),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  :ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index){
                    final student = _students[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: student['thumbnail'] != null
                            ? NetworkImage(student['thumbnail'])
                            : null,
                        child: student['thumbnail'] == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(student['name']),
                      subtitle: Text('Class: ${student['Grade']}'),
                      trailing: Checkbox(
                        value: _selectedStudents.contains(student['id']),
                        onChanged: (value){
                          if(value != null){
                            _toggleStudentSelection(student['id']);
                          }
                        },
                      ),
                    );
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Submit Report'),
                ),
              )
            ],
          ),
    );
  }
}