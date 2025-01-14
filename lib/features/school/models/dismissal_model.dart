import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/logging/logger.dart';

class DismissalModel {
  final String? id;
  final String status;
  final DateTime requestTime;
  // final DateTime? pickupTime;
  final bool authorized;
  String authorizedPickupId;
  String authorizedPickupName;
  String authorizedPickupPhone;
  String authorizedPickupImage;
  // additonal fields
  String studentName;
  String parentName;
  String studentClass;

  DismissalModel({
    this.id,
    required this.status, 
    required this.requestTime, 
    // required this.pickupTime,
    this.authorized = false,
    this.authorizedPickupId = '',
    this.authorizedPickupName = '',
    this.authorizedPickupPhone = '',
    this.authorizedPickupImage = '' ,
    this.studentName = '',
    this.parentName = '',
    this.studentClass = '',
  });

  

  toJson(){
    return {
      'id': id,
      'status': status,
      'requestTime': Timestamp.fromDate(requestTime),
      // 'pickupTime': pickupTime?.toIso8601String(),
      'authorized': authorized,
      'authorizedPickupId': authorizedPickupId,
      'authorizedPickupName': authorizedPickupName,
      'authorizedPickupPhone': authorizedPickupPhone,
      // 'authorizedPickupImage': authorizedPickupImage,
      'studentName': studentName,
      'parentName': parentName,
      'studentClass': studentClass,
    };
  }

  factory DismissalModel.fromMap(Map<String, dynamic>map, String id){
    return DismissalModel(
      id: id,
      status: map['status'] ?? 'Unknown',
      requestTime: (map['requestTime'] as Timestamp).toDate(),
      authorized: map['authorized'] as bool? ?? false,
      authorizedPickupId: map['authorizedPickupId'] ?? '',
      authorizedPickupName: map['authorizedPickupName'] ?? '',
      authorizedPickupPhone: map['authorizedPickupPhone'] ?? '',
      authorizedPickupImage: map['authorizedPickupImage'] ?? '',
      studentName: map['studentName'] ?? '',
      parentName: map['parentName'] ?? '',
      studentClass: map['studentClass'] ?? '',
    );
  }

  factory DismissalModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      SLoggerHelper.error('Error: Document Dismissal ${document.id} has no data.');
      return DismissalModel.empty();
    }

    try {
      return DismissalModel(
        id: document.id,
        status: data['status'] ?? 'Unknown',
        requestTime: data.containsKey('requestTime') 
            ? (data['requestTime'] as Timestamp).toDate() 
            : DateTime.now(),
        authorized: data['authorized'] as bool? ?? false,
        authorizedPickupId: data['authorizedPickupId'] ?? '',
        authorizedPickupName: data['authorizedPickupName'] ?? '',
        authorizedPickupPhone: data['authorizedPickupPhone'] ?? '',
        authorizedPickupImage: data['authorizedPickupImage'] ?? '',
        studentName: data['studentName'] ?? '',
        parentName: data['parentName'] ?? '',
        studentClass: data['studentClass'] ?? '',
      );
    } catch (e) {
      SLoggerHelper.error('Error mapping document ${document.id} to DismissalModel: $e');
      return DismissalModel.empty();
    }
  }

  // Define an empty model for fallback cases
  factory DismissalModel.empty() {
    return DismissalModel(
      id: '',
      status: 'Unknown',
      requestTime: DateTime.now(),
      authorized: false,
      authorizedPickupId: '',
      authorizedPickupName: '',
      authorizedPickupPhone: '',
      authorizedPickupImage: '',
      studentName: '',
      parentName: '',
      studentClass: '',
    );
  }
}