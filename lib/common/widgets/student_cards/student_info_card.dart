import 'package:flutter/material.dart';
import 'package:safetracker/features/school/models/student_model.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';

import '../../../utils/constants/enums.dart';

class StudentInfoCard extends StatelessWidget {
  final StudentModel studentInfo;

  const StudentInfoCard({
    super.key,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    // final controller = StudentController.instance;
    // final isNetworkImage = controller.user.value.profilePicture.isNotEmpty;
    // final image = isNetworkImage ? controller.user.value.profilePicture : SImages.user;
    return Card(
      
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        
      ),
      color: SColors.primaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // SCircularImage(
            //   padding: 0, 
            //   image: student.thumbnail, 
            //   width: 50, 
            //   height: 50, 
            //   isNetworkImage: student.thumbnail.isNotEmpty,
            // ),
            // Student Picture
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(studentInfo.thumbnail),
              onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40), // Fallback for broken images
            ),
            const SizedBox(width: 16),

            // Student Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentInfo.name,
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: SColors.textPrimary),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems/2),
                  Text(
                    'Grade: ${studentInfo.grade?.name ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium!.apply(color: SColors.textSecondary),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems/3),
                  Text(
                    'ID: ${studentInfo.id}',
                    style: Theme.of(context).textTheme.bodyMedium!.apply(color: SColors.textSecondary),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  // Status Rectangle
                  _buildStatusIndicator(studentInfo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(StudentModel student) {
    Color statusColor;
    String statusText;

    switch (student.status) {
      case StudentStatus.present:
        statusColor = Colors.green;
        statusText = 'Present';
        break;
      case StudentStatus.absent:
        statusColor = Colors.red;
        statusText = 'Absent';
        break;
      case StudentStatus.waiting:
        statusColor = Colors.blue;
        statusText = 'Waiting';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor, width: 1.5),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
