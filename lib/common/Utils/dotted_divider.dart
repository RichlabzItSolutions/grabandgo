import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dotSize;
  final double spacing;

  DottedDivider({
    this.height = 1.0,
    this.color = Colors.black,
    this.dotSize = 4.0,
    this.spacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dotSize, // Set height to match the dot size
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          (MediaQuery.of(context).size.width / (dotSize + spacing)).floor(),
              (index) => Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
