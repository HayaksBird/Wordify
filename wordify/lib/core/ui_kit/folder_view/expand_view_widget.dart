import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:wordify/core/ui_kit/colors.dart';


// This is the Painter class
class ExpandViewWidget extends StatelessWidget {
  static const double diameter = 55;
  final VoidCallback expand;
  final bool isExpanded;


  const ExpandViewWidget({
    super.key,
    required this.expand,
    required this.isExpanded
  });


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: const Alignment(0.8, 0.0),
              child: _expandButton()
            ),
          ],
        ),
      ),
    );
  }


  ///
  Widget _expandButton() {
    return GestureDetector(
      onTap: expand,
      child: !isExpanded ? const Icon(
        Icons.keyboard_double_arrow_right_rounded,
        color: AppColors.navigationSecondary,
        size: 25
      )
      :
      const Icon(
        Icons.keyboard_double_arrow_left_rounded,
        color: AppColors.navigationSecondary,
        size: 25
      )
    );
  } 
}



///
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.primary; // Assuming AppColors.primary is Colors.blue
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      -math.pi / 2, // Start angle for vertical semicircle
      math.pi, // Sweep angle for semicircle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}