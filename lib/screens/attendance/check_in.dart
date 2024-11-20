import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/services/database_services.dart';
import 'package:safetracker/services/nfc_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);
  late NfcService _nfcService;
  final Logger _logger = Logger();
  bool _isLoading = true;
  bool _isNfcReadSuccessful = false;

  @override
  void initState() {
    super.initState();
    _nfcService = NfcService(_databaseService);
    _readNfc();
  }

  void _readNfc() async {
    try {
      _isNfcReadSuccessful = await _nfcService.readNfc();
      setState(() {
        _isLoading = false; // Stop loading when NFC read is complete
      });

      if (_isNfcReadSuccessful) {
        _logger.i('NFC read successful');
        // Handle success (e.g., show success message or update UI)
      } else {
        _logger.i('NFC read failed');
        // Show failure message or handle retry
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NFC read failed. Please try again.')),
        );
      }
    } catch (e) {
      _logger.i('Error reading NFC: $e');
      setState(() {
        _isLoading = false; // Stop loading even if there was an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reading NFC: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check In'),
        backgroundColor: const Color.fromRGBO(9, 31, 91, 1),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _isNfcReadSuccessful
                ? const Text('Check In Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                : const Text('Check In Failed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
