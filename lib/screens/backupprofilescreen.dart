// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BackupProfile extends StatefulWidget {
//   const BackupProfile({super.key});

//   @override
//   State<BackupProfile> createState() => _BackupProfileState();
// }

// class _BackupProfileState extends State<BackupProfile> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _childrenController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserInfo();
//   }

//   Future<void> _fetchUserInfo() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
//       if (userDoc.exists) {
//         Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//         setState(() {
//           _nameController.text = userData['displayName'] ?? '';
//           _emailController.text = userData['email'] ?? currentUser.email!;
//           _phoneController.text = userData['phoneNumber'] ?? '';
//           _childrenController.text = userData['children'] ?? '';
//         });
//       }
//     } catch (e) {
//       _showSnackBar('Failed to fetch user information');
//     }
//   }

//   Future<void> _updateUserInfo(String field, String value) async {
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({field: value});
//       if (field == 'displayName') {
//         await currentUser.updateDisplayName(value);
//       } else if (field == 'email') {
//         await currentUser.updateEmail(value);
//       } else if (field == 'phoneNumber') {
//         // Assuming you have proper phone authentication setup.
//         await currentUser.updatePhoneNumber(value);
//       }
//       _showSnackBar('Profile updated successfully');
//     } catch (e) {
//       _showSnackBar('Failed to update profile');
//     }
//   }

//   void _editField(String field, TextEditingController controller) async {
//     String? newValue = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit $field'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(hintText: 'Enter new $field'),
//             keyboardType: field == 'email'
//                 ? TextInputType.emailAddress
//                 : field == 'phoneNumber'
//                     ? TextInputType.phone
//                     : TextInputType.text,
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Save'),
//               onPressed: () {
//                 if (_validateInput(field, controller.text)) {
//                   Navigator.of(context).pop(controller.text);
//                 } else {
//                   _showSnackBar('Invalid input for $field');
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );

//     if (newValue != null && newValue.isNotEmpty) {
//       await _updateUserInfo(field, newValue);
//       setState(() {});
//     }
//   }

//   bool _validateInput(String field, String value) {
//     if (value.isEmpty) {
//       return false;
//     }
//     if (field == 'email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//       return false;
//     }
//     if (field == 'phoneNumber' && !RegExp(r'^\+?1?\d{9,15}$').hasMatch(value)) {
//       return false;
//     }
//     return true;
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(237, 240, 245, 1),
//       body: ListView(
//         children: [
//           const SizedBox(height: 50),
//           const Icon(Icons.person, size: 72),
//           const SizedBox(height: 50),
//           Text(
//             currentUser.email!,
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey[700]),
//           ),
//           const SizedBox(height: 50),
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0),
//             child: Text(
//               'Details',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           ListTile(
//             title: Text('Username'),
//             subtitle: Text(_nameController.text),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => _editField('displayName', _nameController),
//             ),
//           ),
//           ListTile(
//             title: Text('Email'),
//             subtitle: Text(_emailController.text),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => _editField('email', _emailController),
//             ),
//           ),
//           ListTile(
//             title: Text('Phone Number'),
//             subtitle: Text(_phoneController.text),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => _editField('phoneNumber', _phoneController),
//             ),
//           ),
//           ListTile(
//             title: Text('Children'),
//             subtitle: Text(_childrenController.text),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => _editField('children', _childrenController),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
