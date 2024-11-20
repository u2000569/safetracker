import 'package:flutter/material.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';

class SActivityAppBar extends StatelessWidget {
  const SActivityAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SAppBar(
      title: GestureDetector(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity')
          ],
        ),
      ),
    );
  }
}