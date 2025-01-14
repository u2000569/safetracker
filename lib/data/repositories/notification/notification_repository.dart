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

      final result = await _db.collection('Notification').where('userId', isEqualTo: userId).get();
      return result.docs.map((documentSnapshot) => NotificationModel.fromDocument(documentSnapshot)).toList();
    } catch (e) {
      SLoggerHelper.error('Error fetching user notification: $e');
      return [];
    }
  }

  /*------------------- Type(Arrival) User's Notification -------------------*/
  Future<List<NotificationModel>> typeNotification() async{
    try {
      SLoggerHelper.info('fetching type notification Arrival');
      final type = await _db.collection('Notification').where('type', isEqualTo: 'Arrival').get();
      return type.docs.map((documentSnapshot) => NotificationModel.fromDocument(documentSnapshot)).toList();
    } catch (e) {
      SLoggerHelper.error('Error fetching type notification: $e');
      return [];
    }
  } 


  /*------------------- Send User's Notification -------------------*/
  Future<void> sendUserNotification(NotificationModel noti, String userId) async{
    try {
      await _db.collection('Notification').add(noti.toJson());
      SLoggerHelper.info('Notification saved successfully');
    } catch (e) {
      SLoggerHelper.error('Error send notification error from $userId: $e');
    }
  }

  Future<void> updateNotificationStatus(String notificationId, bool status) async {
  try {
    await _db.collection('Notification').doc(notificationId).update({'status': status});
    SLoggerHelper.info('Notification status updated successfully');
  } catch (e) {
    SLoggerHelper.error('Failed to update notification status: $e');
  }
}

}