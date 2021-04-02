import 'package:flutter/material.dart';
import 'package:twentyfourtyeightplus/constants.dart';
import 'dart:async';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  double _spaceHeight = 100;
  int _counter = 4;
  Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter == 0) {
          _decreaseHeight();
          _timer.cancel();
        } else {
          _counter--;
        }
      });
    });
  }

  void _decreaseHeight() {
    setState(() {
      _spaceHeight = 0;
    });
  }

  void initState() {
    super.initState();

    _startTimer();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: tan,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Container(
                width: 270.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: buttonBg,
                ),
                child: Text(
                  " A B O U T   U S ",
                  textAlign: TextAlign.center,
                  style: mainMenuTextStyle,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                height: 450.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 5.0,
                      left: 250.0,
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear,
                            height: _spaceHeight,
                          ),
                          Image(
                            image: AssetImage('images/waving_bear.png'),
                            width: 130.0,
                            height: 130.0,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 70.0,
                      left: 20.0,
                      child: Container(
                        padding: EdgeInsets.all(25.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 177, 121),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          aboutUs,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        constraints:
                            BoxConstraints(maxWidth: 350, maxHeight: 300),
                      ),
                    ),
                    Positioned(
                      top: 335.0,
                      child: Image(
                        image: AssetImage('images/honey_bear.png'),
                        width: 130.0,
                        height: 110.0,
                      ),
                    ),
                  ],
                ),
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
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
