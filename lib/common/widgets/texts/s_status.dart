import 'package:flutter/widgets.dart';

import '../../../utils/constants/enums.dart';
import 's_status_title.dart';

class SStatus extends StatelessWidget {
  const SStatus({
    super.key,
    required this.title, 
    this.maxLines = 1, 
    this.textColor, 
    // this.iconColor = SColors.primary, 
    this.textAlign = TextAlign.center, 
    this.gradeTextSize = TextSizes.small
    });

  final String title;
  final int maxLines;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextSizes gradeTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SStatusTitleText(
            title: title,
            maxLines: maxLines,
            color: textColor,
            textAlign: textAlign,
            gradeTextSize: gradeTextSize,
          ),
        ),
      ],
    );
  }
}