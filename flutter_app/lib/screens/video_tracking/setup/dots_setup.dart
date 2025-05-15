import 'package:flutter/material.dart';

class DotTracker extends StatelessWidget {
  final List<Offset> jointPositions;

  DotTracker({required this.jointPositions});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: jointPositions.map((position) {
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        );
      }).toList(),
    );
  }
}
