import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';

import '../../../utils/constants/enums.dart';
import 's_grade_title_text.dart';

class SGradeNameWithVerifiedIcon extends StatelessWidget {
  const SGradeNameWithVerifiedIcon({
    super.key, 
    required this.title, 
    this.maxLines = 1, 
    this.textColor, 
    this.iconColor = SColors.primary, 
    this.textAlign = TextAlign.center, 
    this.gradeTextSize = TextSizes.small
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes gradeTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SGradeTitleText(
            title: title,
            maxLines: maxLines,
            color: textColor,
            textAlign: textAlign,
            gradeTextSize: gradeTextSize,
          ),
        ),
        const SizedBox(width: SSizes.xs),
        Icon(Iconsax.verify, color: iconColor, size: SSizes.iconXs),
      ],
    );
  }
}