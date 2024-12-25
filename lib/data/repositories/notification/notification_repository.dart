import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../features/school/models/notification_model.dart';

class NotifacationRepository extends GetxController {
  static NotifacationRepository get instance => Get.find();

  /// Variable
  final _db = FirebaseFirestore.instance;

  /*------------------- Fetch User's Notification -------------------*/
  Future<List<NotificationModel>> fetchUserNotification() async{
    try {
      final userId = AuthenticationRepository.instance.getUserId;
    SLoggerHelper.info('Fetching user notification for user: $userId');
    if(userId.isEmpty) throw 'User ID is empty';

    final result = await _db.collection('Notifications').where('userId', isEqualTo: userId).get();
    return result.docs.map((documentSnapshot) => NotificationModel.fromDocument(documentSnapshot)).toList();
    } catch (e) {
      SLoggerHelper.error('Error fetching user notification: $e');
      return [];
    }
  }

  /*------------------- Send User's Notification -------------------*/
  Future<void> sendUserNotification(NotificationModel noti, String userId) async{
    try {
      await _db.collection('Notification').add(noti.toJson());
      SLoggerHelper.info('Notification saved successfully');
    } catch (e) {
      SLoggerHelper.error('Error send notification error to $userId: $e');
    }
  }
}