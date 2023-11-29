
import 'package:flutter/material.dart';

class MyCustomPath extends CustomPainter{
  // Il s'agit d'une vague positionnée en bas de l'écran, la vague doit avoir un reflet un peu plus clair
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepOrangeAccent[200]!
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.75, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.85, size.width, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.85, size.width * 0.5, size.height * 0.8);
    path2.quadraticBezierTo(size.width * 0.75, size.height * 0.75, size.width, size.height * 0.8);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}