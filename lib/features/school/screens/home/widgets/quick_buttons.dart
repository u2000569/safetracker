import 'package:flutter/material.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const QuickActionButton({
    super.key,
    required this.icon, 
    required this.label, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(SSizes.defaultSpace),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorDark,
            ),
            child: Icon(icon, size: 32.0, color: SColors.white,),
          ),
        ),
        const SizedBox(height: SSizes.spaceBtwInputFields),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}