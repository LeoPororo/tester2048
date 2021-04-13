import 'package:flutter/material.dart';

import 'constants.dart';

class ProgressBarPainter extends CustomPainter {
  ProgressBarPainter({this.progressBarValue, this.state, this.screenWidth});

  int progressBarValue;
  bool state;
  double screenWidth;

  @override
  void paint(Canvas canvas, Size size) {
    double maxWidth = screenWidth - 16 * 2;
    double widthOffset = 5;
    var yOffset = 5.0;
    final p1 = Offset(widthOffset, yOffset);
    final p2 = Offset(maxWidth + widthOffset, yOffset);
    final paint = Paint()
      ..color = state ? progressBarBg : darkBrown
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    canvas.drawLine(p1, p2, paint);
    final endLine = Offset(maxWidth + widthOffset, yOffset);
    double unit = maxWidth / maxTimerInSeconds;
    double startingWidth = maxWidth + unit;
    double operation = startingWidth - unit * ((maxTimerInSeconds + 1) - progressBarValue);
    var p3 = Offset(operation, yOffset);
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
