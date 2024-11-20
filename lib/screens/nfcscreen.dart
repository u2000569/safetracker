import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:safetracker/components/bot_navigation.dart';
import 'package:safetracker/services/database_services.dart';
import 'package:safetracker/services/nfc_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NfcScreen extends StatefulWidget {
  @override
  _NfcScreenState createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  String _nfcData = 'No data';
  final TextEditingController _controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);
  late NfcService _nfcService;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Data: $_nfcData'),
            // TextField(
            //   controller: _controller,
            //   decoration: InputDecoration(labelText: 'Enter data to write'),
            // ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _readNfc,
                  child:const Text('Check In'),
                ),
                // ElevatedButton(
                //   onPressed: _writeNfc,
                //   child: Text('Write NFC'),
                // ),
                // ElevatedButton(
                //   onPressed: _updateNfc,
                //   child: Text('Update NFC'),
                // ),
                // ElevatedButton(
                //   onPressed: _deleteNfc,
                //   child: Text('Delete NFC'),
                // ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _databaseService.getAttendanceStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No data found');
                  }

                  final data = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final timestamp = item['timestamp'] != null ? (
                        item['timestamp'] as Timestamp)
                        .toDate() : null;
                      final formattedTimestamp = timestamp != null ? DateFormat('dd-MM-yyyy HH:mm').format(timestamp):'No timestamp';                      
                        return ListTile(
                        title: Text('Student ID: ${item['studentId']}'),
                        subtitle: Text('Check In Time: $formattedTimestamp'),                      
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _readNfc() async {
    try {
      await _nfcService.readNfc();
    } catch (e) {
      print('Error reading NFC: $e');
    }
  }

  void _writeNfc() async {
    try {
      await _nfcService.writeNfc(_controller.text);
      _showMessage('Data written to NFC');
    } catch (e) {
      print('Error writing to NFC: $e');
    }
  }

  void _updateNfc() async {
    try {
      await _nfcService.updateNfc(_controller.text);
      _showMessage('Data updated on NFC');
    } catch (e) {
      print('Error updating NFC: $e');
    }
  }

  void _deleteNfc() async {
    try {
      await _nfcService.deleteNfc();
      _showMessage('Data deleted from NFC');
    } catch (e) {
      print('Error deleting NFC: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
