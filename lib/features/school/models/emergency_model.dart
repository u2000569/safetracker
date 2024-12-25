import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyModel {
  String reportId;
  String locationEmergency;
  String details;
  String typeEmergency;
  String imageEmergency;
  final DateTime timestamp;

  EmergencyModel({
    required this.reportId,
    required this.locationEmergency,
    required this.details,
    required this.typeEmergency,
    this.imageEmergency = '',
    required this.timestamp,
  });

  /// Empty Helper Function
  static EmergencyModel empty() => EmergencyModel(
        reportId: '',
        details: '',
        locationEmergency: '',
        typeEmergency: '',
        imageEmergency: '',
        timestamp: DateTime.timestamp(),
  );

  /// Convert model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'reportId': reportId,
      'locationEmergency': locationEmergency,
      'details': details,
      'typeEmergency': typeEmergency,
      'imageEmergency': imageEmergency,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory EmergencyModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return EmergencyModel(
        reportId: document.id,
        locationEmergency: data['locationEmergency'] ?? '',
        details: data['details'] ?? '',
        typeEmergency: data['typeEmergency'] ?? '',
        imageEmergency: data['imageEmergency'] ?? '',
        timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } else {
      return EmergencyModel.empty();
    }
  }
}