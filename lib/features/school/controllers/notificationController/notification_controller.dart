import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/home_menu.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/full_screen_loader.dart';

import '../../../../data/repositories/notification/notification_repository.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/notification_model.dart';
import '../student/student_controller.dart';

class NotificationController extends GetxController{
  static NotificationController get instance => Get.find();

  // Variable
  final studentController = Get.put(StudentController());
  final userController = UserController.instance;
  final notificationRepository = Get.put(NotifacationRepository());

  // fetch User's Notificaiton
  Future<List<NotificationModel>> fetchUserNotification() async{
    try{
      final userNotification = await notificationRepository.typeNotification();
      return userNotification;
    } catch(e){
      SLoggerHelper.error('Error fetching user notification: $e');
      return [];
    }
  }

  /*------------------- Sending User's Notification -------------------*/
  void procesSendNotification() async{
    try {
      // variable
      final parentName = userController.user.value.fullName;
      final studentName = studentController.studentParent.value?.name ?? '';
      SLoggerHelper.info('procesSendNotification function: Parent Name: $parentName, Student Name: $studentName');
      SFullScreenLoader.openLoadingDialog('Sending Notification.....', SImages.loadingAnimation);

      // Get user ID
      final userId = AuthenticationRepository.instance.getUserId;
      SLoggerHelper.info('Sending notification from user: $userId');

      if(userId.isEmpty) return;

      // Add notification
      final notification = NotificationModel(
        id: UniqueKey().toString(),
        userId: userId, 
        title: "Arrived", 
        message: 'Mr/Mrs $parentName has arrived to pick up $studentName', 
        type: 'Arrival', 
        status: false, 
        createdAt: DateTime.now(),
      );

      // Send notification
      await notificationRepository.sendUserNotification(notification, userId);

      Get.off(() => const HomeMenu());

    } catch (e) {
      SLoggerHelper.error('Failed to send notification: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
  try {
    await notificationRepository.updateNotificationStatus(notificationId, true);
    SLoggerHelper.info('Notification marked as read: $notificationId');
  } catch (e) {
    SLoggerHelper.error('Failed to mark notification as read: $e');
  }
}

}