import 'package:flutter/material.dart';

import 'constants.dart';

class ProgressBarPainter extends CustomPainter {
  ProgressBarPainter({this.progressBarValue, this.state});

  int progressBarValue;
  bool state;

  @override
  void paint(Canvas canvas, Size size) {
    double maxWidth = 370;
    double widthOffset = 5;
    final p1 = Offset(widthOffset, 10);
    final p2 = Offset(maxWidth + widthOffset, 10);
    final paint = Paint()
      ..color = state ? progressBarBg : darkBrown
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    canvas.drawLine(p1, p2, paint);
    final endLine = Offset(375, 10);
    double unit = maxWidth / maxTimerInSeconds;
    double startingWidth = maxWidth + unit;
    double operation = startingWidth - unit * ((maxTimerInSeconds + 1) - progressBarValue);
    var p3 = Offset(operation, 10);
    final rePainted = Paint()
      ..color = progressBarCap
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
