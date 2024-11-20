import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:safetracker/services/database_services.dart';

class NfcService {
  final DatabaseService _databaseService;
  NfcService(this._databaseService);

  Future<bool> readNfc() async {
    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        throw Exception('NFC is not available');
      }

      var tag = await FlutterNfcKit.poll(
        //timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag",
      );

      if (tag.ndefAvailable != null && tag.ndefAvailable!) {
        var records = await FlutterNfcKit.readNDEFRecords(cached: false);
        if (records.isNotEmpty && records.first.payload != null) {
          // Extract payload and remove the language code
        var payload = records.first.payload!;
        int languageCodeLength = payload[0]; // The first byte is the language code length
        String studentId = String.fromCharCodes(
          payload.sublist(languageCodeLength + 1), // Skip language code
        );

          // Store attendance data
          await _databaseService.createAttendanceData(studentId);

          // Fetch student data
          var studentData = await _databaseService.getStudentData(studentId);
          if (studentData.exists) {
            print('Student Name: ${studentData['studentName']}');
          } else {
            print('No student data found');
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      await FlutterNfcKit.finish();
    }
    
  }

  Future<void> writeNfc(String data) async {
    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        throw Exception('NFC is not available');
      }

      var tag = await FlutterNfcKit.poll(
        timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag",
      );

      if (tag.ndefWritable != null && tag.ndefWritable!) {
        await FlutterNfcKit.writeNDEFRecords([
          ndef.TextRecord(),
        ]);
      } else {
        throw Exception('NFC tag is not writable');
      }
    } catch (e) {
      rethrow;
    } finally {
      await FlutterNfcKit.finish(iosAlertMessage: "Data written successfully");
    }
  }

  Future<void> updateNfc(String data) async {
    await writeNfc(data);
  }

  Future<void> deleteNfc() async {
    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        throw Exception('NFC is not available');
      }

      var tag = await FlutterNfcKit.poll(
        timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag",
      );

      if (tag.ndefWritable != null && tag.ndefWritable!) {
        await FlutterNfcKit.writeNDEFRecords([]);
      } else {
        throw Exception('NFC tag is not writable');
      }
    } catch (e) {
      rethrow;
    } finally {
      await FlutterNfcKit.finish(iosAlertMessage: "Data deleted successfully");
    }
  }
}
