// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:safetracker/components/my_textfield.dart';
// import 'package:safetracker/services/database_services.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final user = FirebaseAuth.instance.currentUser;
//   final studentCollection = FirebaseFirestore.instance.collection('StudentData');
//   bool isEditing = true;
//   Logger _logger =Logger();

//   final _formKey = GlobalKey<FormState>();
//   //identify string
//   String studentName = '', studentId = '', studentAddress = '', studentClass = '';
//   //student field form
//   final studentNameField = TextEditingController();
//   final studentAddressField = TextEditingController();
//   final studentClassField = TextEditingController();
//   final studentIdField = TextEditingController();
  
//   Future<void> saveStudentInfo() async{
//     _logger.i('Save Information Of Student Doc');
//     if(_formKey.currentState!.validate()){
//       _logger.i('Fill In Data');
//       setState(() {
//         studentName = studentNameField.text;
//         studentId = studentIdField.text;
//         studentAddress = studentAddressField.text;
//         studentClass = studentClassField.text;
//       });
//       await DatabaseService(uid: user?.uid ).studentData(
//         studentName, studentId, studentAddress, studentClass
//       );
//       setState(() {
//         isEditing = false;
//       });

//     }
//   }

//   //Fetch Data
//   Future<void> fetchStudentInfo() async {
//     final studentData = await DatabaseService(uid: user?.uid).studentData(
//       studentName, studentId, studentAddress, studentClass);
//     if (studentData == null) {
//       _logger.i('Read Data');
//       setState(() {
//         studentNameField.text = studentData['studentName'] ?? '';
//         studentAddressField.text = studentData['studentAddress'] ?? '';
//         studentClassField.text = studentData['studentClass'] ?? '';
//         studentIdField.text = studentData['studentId'] ?? '';
//         // imageUrl = studentData['imageUrl'];
//         isEditing = false;
//       });
//     } else {
//       setState(() {
//         isEditing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text('HomeScreen'),
//           )
//         ),
//       // drawer: MyDrawer(
//       //   onProfileTap: goToProfilePage, 
//       //   onLogout: signUserOut),
//       body: SingleChildScrollView(
//         padding:const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (isEditing) ...[
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: pickImage,
//                       child:const CircleAvatar(
//                         radius: 50,
//                       ),
//                     ),
//                     const SizedBox(height: 20,),
//                     MyTextField(
//                       controller:studentNameField, 
//                       hintText: 'Student Name', 
//                       obscureText: false),
                    
//                     const SizedBox(height: 20,),
//                     MyTextField(
//                       controller:studentIdField, 
//                       hintText: 'Student ID', 
//                       obscureText: false),

//                     const SizedBox(height: 20,),
//                     MyTextField(
//                       controller:studentAddressField, 
//                       hintText: 'Please Enter Your Address', 
//                       obscureText: false),

//                     const SizedBox(height: 20,),
//                     MyTextField(
//                       controller:studentClassField, 
//                       hintText: 'Class', 
//                       obscureText: false),

//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: saveStudentInfo,
//                       child: const Text('Save'),
//                     ),
//                   ],
//                 )
//               )
//             ]else ...[
//               const CircleAvatar(
//                 radius: 50,
//               ),
//               const SizedBox(height: 20,),
//               Text('Name: $studentName'),
//               const SizedBox(height: 20,),
//               Text('Student ID: $studentId'),
//               const SizedBox(height: 20,),
//               Text('Address: $studentAddress'),
//               const SizedBox(height: 20,),
//               Text('Class: $studentClass'),

//               const SizedBox(height: 20,),
//               ElevatedButton(onPressed: (){
//                 setState(() {
//                   isEditing = true;
//                 });
//               }, child: const Text('Edit Information'),
//               )
//             ]
//           ],
//         ),
//         )

       
//     );
//   }

//   void pickImage() {
//   }
// }