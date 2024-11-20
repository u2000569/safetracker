import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Emergency Drill',
      detail: 'Emergency drill scheduled at 10 AM.',
      time: '9:00 AM',
    ),
    NotificationItem(
      title: 'Fire Drill',
      detail: 'Fire drill will start at 11 AM.',
      time: '10:30 AM',
    ),
    NotificationItem(
      title: 'Medical Checkup',
      detail: 'Medical checkup camp at 2 PM.',
      time: '1:00 PM',
    ),
    NotificationItem(
      title: 'Raining Alert',
      detail: 'Heavy rain expected at 4 PM.',
      time: '3:30 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Notifications',
        style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(9, 31, 91, 1),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String detail;
  final String time;

  NotificationItem({required this.title, required this.detail, required this.time});
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notification.detail),
        trailing: Text(notification.time),
      ),
    );
  }
}
