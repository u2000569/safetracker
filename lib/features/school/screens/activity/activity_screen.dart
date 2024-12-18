import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:safetracker/features/school/screens/activity/attendance/attendance_screen.dart';
import 'package:safetracker/features/school/screens/activity/widget_activity/activity_appbar.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/helpers/helper_functions.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = SHelperFunctions.isDarkMode(context);
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const SPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SActivityAppBar(),
                  SizedBox(height: SSizes.spaceBtwSections),
                ],
              )
            ),
            Container(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
              child: Column(
                children: [
                  _buildActivityCard(
                    context,
                    icon: Icons.check_circle,
                    title: 'Attendance',
                    onTap: () {
                      Get.to(AttendanceScreen());
                    },
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  _buildActivityCard(
                    context,
                    icon: Icons.error,
                    title: 'Emergency',
                    onTap: () {
                      // Get.toNamed(SRoutes.assignments);
                    },
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  _buildActivityCard(
                    context,
                    icon: Icons.note,
                    title: 'Hall Pass',
                    onTap: () {
                      // Get.toNamed(SRoutes.assignments);
                    },
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  _buildActivityCard(
                    context,
                    icon: Icons.time_to_leave,
                    title: 'Dismissal',
                    onTap: () {
                      // Get.toNamed(SRoutes.assignments);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildActivityCard(BuildContext context,
{
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}){
  final dark = SHelperFunctions.isDarkMode(context);
  return Card(
    color: dark ? Colors.black : Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusMd),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSizes.borderRadiusMd),
      child: Padding(
        padding: const EdgeInsets.all(SSizes.spaceBtwItems),
        child: Row(
          children: [
            Icon(icon, size: SSizes.iconLg, color: dark ? SColors.white : SColors.black),
            SizedBox(width: SSizes.spaceBtwItems),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: dark ? SColors.white : SColors.black,
              ),  
            )
          ],
        ),
        ),
    )
  );
}