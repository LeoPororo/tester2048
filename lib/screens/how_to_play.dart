import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
            Image(image: AssetImage('images/Slide1.PNG')),
            Image(image: AssetImage('images/Slide2.PNG')),
            Image(image: AssetImage('images/Slide3.PNG')),
          ],
        ),
      ),
    ));
  }
}
