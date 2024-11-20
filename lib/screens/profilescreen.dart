import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safetracker/components/text_box.dart';

class OldProfileScreen extends StatefulWidget {
  const OldProfileScreen({super.key});

  @override
  State<OldProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OldProfileScreen> {
  // Current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // Edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter New $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          // Save button
          TextButton(
            onPressed: () {
              if (newValue.trim().isNotEmpty) {
                Navigator.of(context).pop(newValue);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ).then((value) async {
      if (value != null && value.trim().isNotEmpty) {
        await userCollection.doc(currentUser.uid).update({field: value});
      }
    });
  }

  // Logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Adjust this to your login route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile Setting',
        style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(9, 31, 91, 1),
      ),
      backgroundColor: const Color.fromRGBO(237, 240, 245, 1),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final data = snapshot.data!.data();
            if (data == null) {
              return const Center(
                child: Text('No data available'),
              );
            }

            final userData = data as Map<String, dynamic>;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 50),
                      const Icon(
                        Icons.person,
                        size: 72,
                      ),
                      const SizedBox(height: 50),
                      // User email
                      Text(
                        currentUser.email!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 50),
                      // User Details
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          'Details',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      // Username
                      MyTextBox(
                        sectionName: 'Name',
                        text: userData['fullName'] ?? 'N/A',
                        onPressed: () => editField('fullName'),
                      ),
                      // Email
                      // MyTextBox(
                      //   sectionName: 'Email',
                      //   text: currentUser.email!,
                      //   onPressed: () => editField('email'),
                      // ),
                      // Phone Number
                      MyTextBox(
                        sectionName: 'Phone Number',
                        text: userData['phoneNumber'] ?? 'N/A',
                        onPressed: () => editField('phoneNumber'),
                      ),
                      // Children
                      // MyTextBox(
                      //   sectionName: 'Children',
                      //   text: userData['children'] ?? 'N/A',
                      //   onPressed: () => editField('children'),
                      // ),
                    ],
                  ),
                ),
                // Logout button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set the background color
                    ),
                    child: const Text('Logout',
                    style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
