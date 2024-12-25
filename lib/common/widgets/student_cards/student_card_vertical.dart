import 'package:flutter/widgets.dart';
import 'package:safetracker/common/styles/shadows.dart';

import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/enums.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/helpers/helper_functions.dart';

// import '../../../features/school/controllers/student/student_controller.dart';
import '../../../features/school/models/student_model.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/s_rounded_image.dart';
import '../texts/s_grade_name_verify.dart';
import '../texts/s_status.dart';
import '../texts/s_student_name_text.dart';

class SStudentCardVertical extends StatelessWidget {
  const SStudentCardVertical({
    super.key, 
    required this.student, 
    this.isNetworkImage = true,
  });

  final StudentModel student;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {

    // final studentController = StudentController.instance;
    final dark = SHelperFunctions.isDarkMode(context);
    return GestureDetector(
      // onTap: () => Get.to(() => StudentDetailScreen(student: student)),

      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [SShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(SSizes.productImageRadius),
          color: dark ? SColors.darkGrey : SColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Thumbnail
            SRoundedContainer(
              height: SSizes.productItemHeight,
              width: double.infinity,
              padding: const EdgeInsets.all(SSizes.sm),
              backgroundColor: dark ? SColors.dark: SColors.white,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(SSizes.sm),
                    child: SRoundedImage(imageUrl: student.thumbnail, applyImageRadius: true, isNetworkImage: isNetworkImage)
                  ,
                  ),
                  /// Thumbnail Image
                  
                  const SizedBox(height: SSizes.spaceBtwItems,),
                  Padding(
                    padding: const EdgeInsets.only(left : SSizes.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SStudentNameText(name: student.name, smallSize: true),
                        const SizedBox(height: SSizes.spaceBtwItems/2),
                        SGradeNameWithVerifiedIcon(title: student.grade!.name, gradeTextSize: TextSizes.small),
                        const SizedBox(height: SSizes.spaceBtwItems/2),
                        SStatus(title: student.studentStatusText, gradeTextSize: TextSizes.small),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwItems/2),
            /// Details
            

          ],
        ),
      ),
    );
  }
}