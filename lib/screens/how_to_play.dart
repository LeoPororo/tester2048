import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twentyfourtyeightplus/constants.dart';

class HowToPlay extends StatefulWidget {
  @override
  _HowToPlayState createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image(image: AssetImage('images/howtoplay.png')),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: tan,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    style: buttonStyle,
                    child: Container(
                      width: 150.0,
                      height: 60.0,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "B A C K",
                        textAlign: TextAlign.center,
                        style: mainMenuTextStyle,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
