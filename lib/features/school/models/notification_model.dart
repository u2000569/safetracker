import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safetracker/utils/helpers/helper_functions.dart';

class NotificationModel{
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool status;
  final DateTime createdAt;

  NotificationModel({
    required this.id, 
    this.userId = '', 
    required this.title, 
    required this.message, 
    required this.type, 
    required this.status, 
    required this.createdAt
  });

  String get formattedNotificationDate => SHelperFunctions.getFormattedDate(createdAt);

  static NotificationModel empty() => NotificationModel(
    id: '',
    userId: '',
    title: '',
    message: '',
    type: '',
    status: false,
    createdAt: DateTime.now(),
  );

  toJson(){
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  factory NotificationModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return NotificationModel(
      id: data.containsKey('id') ? data['id'] : document.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? '',
      status: data.containsKey('status') ? data['status'] as bool : true,
      createdAt: data.containsKey('createdAt') ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      );
    } else {
      return NotificationModel.empty();
    }
  }
}