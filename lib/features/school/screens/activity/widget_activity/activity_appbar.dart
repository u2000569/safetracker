import 'package:flutter/material.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/utils/constants/colors.dart';

class SActivityAppBar extends StatelessWidget {
  const SActivityAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SAppBar(
      title: GestureDetector(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
            style: TextStyle(
              color: SColors.textWhite,
              fontSize: 22
            ),
          )
          ],
        ),
      ),
    );
  }
}