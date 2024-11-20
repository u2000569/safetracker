import 'package:flutter/material.dart';

class SStudentNameText extends StatelessWidget {
  const SStudentNameText({
    super.key, 
    required this.name, 
    this.smallSize = false, 
    this.maxLines = 2, 
    this.textAlign = TextAlign.left,
  });

  final String name;
  final bool smallSize;
  final int maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: !smallSize ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelLarge,
    );
  }
}