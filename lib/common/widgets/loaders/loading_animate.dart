import 'package:flutter/material.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/constants/sizes.dart';

class SLoadingAnimate extends StatelessWidget {
  const SLoadingAnimate({
    super.key, 
    this.height = 200, 
    this.width = 200
  });

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image(image: AssetImage(SImages.paperPlaneAnimation), height: height, width: width),
          const SizedBox(height: SSizes.spaceBtwItems),
          const Text('Loading your data ...'),
        ],
      ),
    );
  }
}