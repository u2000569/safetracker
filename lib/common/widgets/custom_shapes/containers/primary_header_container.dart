import 'package:flutter/material.dart';
import 'package:safetracker/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:safetracker/utils/constants/colors.dart';

import 'circular_container.dart';
/// A container widget with a primary color background and curved edges.
class SPrimaryHeaderContainer extends StatelessWidget {
  /// Create a container with a primary color background and curved edges.
  ///
  /// Parameters:
  ///   - child: The widget to be placed inside the container.
  const SPrimaryHeaderContainer({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SCurvedEdgeWidget(
      child: Container(
        color: SColors.primary,
        padding: const EdgeInsets.only(bottom: 0,),

        child: Stack(
          children: [
            /// -- BAckground Custom Shape --
            Positioned(
              top: -150, right: -250, child: SCircularContainer(backgroundColor: SColors.white.withOpacity(0.1)),
            ),
            Positioned(
              top: -100, left: -300, child: SCircularContainer(backgroundColor: SColors.white.withOpacity(0.1)),
            ),
            child
          ],
        ),
      ),
    );
  }
}