import 'package:flutter/material.dart';

class RightCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF0C5674);

    Path path = Path();
    path.moveTo(0, 0); // start at top-left
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 1.2, size.width, size.height); // curve
    path.lineTo(size.width, 0); // top-right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}