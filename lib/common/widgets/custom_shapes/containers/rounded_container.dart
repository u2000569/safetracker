import 'package:flutter/widgets.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';

class SRoundedContainer extends StatelessWidget {
  const SRoundedContainer({
    super.key, 
    this.width, 
    this.height, 
    this.radius = SSizes.cardRadiusLg, 
    this.padding = const EdgeInsets.all(SSizes.md), 
    this.margin, 
    this.child, 
    this.backgroundColor = SColors.white, 
    this.borderColor = SColors.borderPrimary, 
    this.showBorder = false
  });

  final double? width;
  final double? height;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color backgroundColor;
  final Color borderColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}