import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'constants.dart';
import 'main.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: tan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 350.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 75.0,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 1900),
                      text: ["2"],
                      textStyle: TextStyle(
                        fontSize: 125.0,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 242, 177, 121),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(
                    width: 75.0,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 1950),
                      text: ["0"],
                      textStyle: TextStyle(
                        fontSize: 125.0,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 246, 95, 64),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(
                    width: 75.0,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 2000),
                      text: ["4"],
                      textStyle: TextStyle(
                        fontSize: 125.0,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 237, 203, 103),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(
                    width: 75.0,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 2050),
                      text: ["8"],
                      textStyle: TextStyle(
                        fontSize: 125.0,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 232, 192, 70),
                      ),
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minWidth: 300.0,
              height: 60.0,
              hoverColor: Colors.amberAccent,
              color: Color.fromARGB(255, 246, 124, 95),
              disabledColor: Colors.grey,
              disabledTextColor: Colors.grey,
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home2048()));
              },
              child: Text(
                "S T A R T   G A M E ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'PatrickHand',
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minWidth: 300.0,
              height: 60.0,
              hoverColor: Colors.amberAccent,
              color: Color.fromARGB(255, 246, 124, 95),
              disabledColor: Colors.grey,
              disabledTextColor: Colors.grey,
              padding: EdgeInsets.all(10.0),
              onPressed: () {},
              child: Text(
                "H O W   T O   P L A Y ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'PatrickHand',
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minWidth: 300.0,
              height: 60.0,
              hoverColor: Colors.amberAccent,
              color: Color.fromARGB(255, 246, 124, 95),
              disabledColor: Colors.grey,
              disabledTextColor: Colors.grey,
              padding: EdgeInsets.all(10.0),
              onPressed: () {},
              child: Text(
                "A B O U T   U S ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'PatrickHand',
                ),
              ),
            ),
            SizedBox(
              height: 55.0,
            ),
          ],
        ),
      ),
    );
  }
}
