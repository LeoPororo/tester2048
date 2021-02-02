import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerProgressBar extends StatelessWidget {
  final double width;
  final int value;
  final int totalValue;
  TimerProgressBar({this.width, this.value, this.totalValue});

  Color _getColorByRatio(double ratio) {
    if (ratio < 0.3) return Colors.red;
    if (ratio < 0.6) return Colors.amber;
    return Colors.lightGreen;
  }

  @override
  Widget build(BuildContext context) {
    double ratio = value / totalValue;

    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.timer,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  width: width,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(5.0),
                  elevation: 3,
                  child: AnimatedContainer(
                    width: width * ratio,
                    height: 10.0,
                    duration: Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                        color: _getColorByRatio(ratio),
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
