import 'package:flutter/material.dart';
import 'package:safetracker/utils/constants/sizes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              Text("New", style: Theme.of(context).textTheme.headlineMedium),
              // CustomFollowNotification(),
            ],
          ),
        ),
      ),
    );
  }
}