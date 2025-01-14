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
              color: Theme.of(context).cardColor,
              boxShadow: List<BoxShadow>.generate(3, (int index) => BoxShadow(
                color: SColors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              )),
              
            ),
            child: Icon(icon, size: 32.0, color: SColors.primary,),
          ),
        ),
        const SizedBox(height: SSizes.xs),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}