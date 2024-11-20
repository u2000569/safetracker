import 'package:flutter/material.dart';
import 'package:safetracker/common/widgets/custom_shapes/curved_edges/curved_edges.dart';

class SCurvedEdgeWidget extends StatelessWidget {
  const SCurvedEdgeWidget({
    super.key, 
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      // Use customed clipper to create the curved edges
      clipper: SCustomCurvedEdges(),
      child: child,
    );
  }
}