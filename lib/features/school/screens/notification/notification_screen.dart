import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safetracker/features/personalization/controllers/user_controller.dart';
import 'package:safetracker/features/school/controllers/notificationController/notification_controller.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/image_strings.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController());

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final userId = userController.user.value.id;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8), // Set background to off-white
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: notificationController.fetchUserNotification(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(
                      color: SColors.primary,
                      semanticsLabel: 'Loading Notifications',
                      semanticsValue: 'Loading Notifications',
                    ));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No notifications available.'));
                  }

                  final notifications = snapshot.data!;
                  notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0), // Add padding to the list
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];

                      // Format the time and date
                      final date = DateFormat('yyyy-MM-dd').format(notification.createdAt);
                      final time = DateFormat('HH:mm').format(notification.createdAt);
                      
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Make card rectangular with slight roundness
                        ),
                        elevation: 2, // Add shadow for better look
                        margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Card background color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16.0), // Padding inside the card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.access_alarm),
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                notification.message,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$date at $time",
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      color: SColors.darkGrey,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: notification.status
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : ElevatedButton(
                                            onPressed: () async {
                                              await notificationController.markNotificationAsRead(notification.id);
                                              // Refresh UI
                                              (context as Element).markNeedsBuild();
                                            },
                                            child: const Text('Mark as Read'),
                                          ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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
}
