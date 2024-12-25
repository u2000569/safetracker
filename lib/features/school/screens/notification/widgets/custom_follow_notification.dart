import 'package:flutter/material.dart';
import 'package:safetracker/utils/constants/image_strings.dart';

class CustomFollowNotification extends StatefulWidget {
  const CustomFollowNotification({super.key});

  @override
  State<CustomFollowNotification> createState() => _CustomFollowNotificationState();
}

class _CustomFollowNotificationState extends State<CustomFollowNotification> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(SImages.user),
        ),
        const SizedBox(width: 15),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

          ],
        )
      ],
    );
  }
}