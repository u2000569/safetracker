
import 'package:flutter/material.dart';
import '../../../utils/constants/enums.dart';

class SGradeTitleText extends StatelessWidget {
  const SGradeTitleText({
    super.key, 
    this.color, 
    required this.title, 
    this.maxLines = 1, 
    this.textAlign = TextAlign.center, 
    this.gradeTextSize = TextSizes.small,
  });

  final Color? color;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes gradeTextSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      // Check which brandSize is required and set that style.
      style: gradeTextSize == TextSizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
          : gradeTextSize == TextSizes.medium
              ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
              : gradeTextSize == TextSizes.large
                  ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
                  : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
    );
  }
}