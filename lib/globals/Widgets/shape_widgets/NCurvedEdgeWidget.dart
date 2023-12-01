import 'package:flutter/material.dart';
import '../../custom_shapes/curved_edges.dart';



class NCurvedEdgesWidget extends StatelessWidget {
  const NCurvedEdgesWidget({
    super.key,this.child
  });
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: NCustomCurvedEdges(),
        child: child
    );
  }
}