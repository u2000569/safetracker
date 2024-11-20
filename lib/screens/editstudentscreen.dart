import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class EditStudentScreen extends StatefulWidget {
  final String uid;

  const EditStudentScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  final _formKey = GlobalKey<FormState>();
  final studentNameController = TextEditingController();
  final studentIdController = TextEditingController();
  final studentAddressController = TextEditingController();
  final studentClassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    DocumentSnapshot doc = await _firestore.collection('Users').doc(widget.uid).collection('StudentInfo').doc('studentId').get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      studentNameController.text = data['studentName'];
      studentIdController.text = data['studentId'];
      studentAddressController.text = data['studentAddress'];
      studentClassController.text = data['studentClass'];
    } else {
      _logger.i("No Student Info found");
    }
  }

  Future<void> _updateStudentInfo() async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('Users').doc(widget.uid).collection('StudentInfo').doc('studentId').update({
        'studentName': studentNameController.text,
        'studentId': studentIdController.text,
        'studentAddress': studentAddressController.text,
        'studentClass': studentClassController.text,
      }).then((_) {
        _logger.i("Student Info Updated");
        Navigator.pop(context);
      }).catchError((error) {
        _logger.e("Failed to update student info: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: studentNameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: studentIdController,
                decoration: InputDecoration(labelText: 'Student ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: studentAddressController,
                decoration: InputDecoration(labelText: 'Student Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: studentClassController,
                decoration: InputDecoration(labelText: 'Student Class'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student class';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStudentInfo,
                child: Text('Update Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
