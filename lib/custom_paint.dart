import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  MyPainter({this.paintCounter});

  @override
  int paintCounter;
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(5, 10);
    final p2 = Offset(375, 10);
    final paint = Paint()
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    canvas.drawLine(p1, p2, paint);
    final endLine = Offset(375, 10);
    int operation = 407 - 37 * (11 - paintCounter);
    var p3 = Offset(operation.toDouble(), 10);
    final rePainted = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    canvas.drawLine(p3, endLine, rePainted);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    // This should be always true if you want to repaint / redraw the progress bar
    return true;
  }
}
