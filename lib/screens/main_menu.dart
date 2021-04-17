// TODO: Move constant designs to constants.dart once main menu design is complete

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:twentyfourtyeightplus/screens/about_us.dart';
import 'package:twentyfourtyeightplus/screens/how_to_play.dart';
import '../admob/ad_manager.dart';
import '../constants.dart';
import 'game_view.dart';

class MainMenuWidget extends StatefulWidget {
  @override
  _MainMenuWidgetState createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  AdmobBannerSize bannerSize;

  @override
  void initState() {
    super.initState();

    bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print(width);
    var titleHeight = 290.0;
    var titleFontSize = 125.0;
    var letterWidth = 75.0;
    var letterSpacing = 20.0;

    // BUTTONS
    var buttonFontSize = 30.0;
    var buttonWidth = 270.0;
    var buttonHeight = 60.0;

    // TABLETS
    if (width > 600) {
      titleHeight = 500.0;
      titleFontSize = 250.0;
      letterWidth = 120.0;
      letterSpacing = 20.0;
      buttonFontSize = 50.0;
      buttonWidth = 450.0;
      buttonHeight = 90.0;
    } else if (width > 500) {
      titleHeight = 500.0;
      titleFontSize = 250.0;
      letterWidth = 120.0;
      letterSpacing = 20.0;
      buttonFontSize = 50.0;
      buttonWidth = 450.0;
      buttonHeight = 90.0;
    }
    // SMALL SMARTPHONE
    else if (width < 400) {
      titleFontSize = 100.0;
      titleHeight = 180.0;
      letterWidth = 60.0;
    }

    return Scaffold(
      body: Container(
        color: tan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: AdmobBanner(
                adUnitId: AdManager.bannerByUsage("MAIN_MENU"),
                adSize: bannerSize,
                listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                  AdManager.handleEvent(event, args, 'Banner');
                },
                onBannerCreated: (AdmobBannerController controller) {
                  // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                  // Normally you don't need to worry about disposing this yourself, it's handled.
                  // If you need direct access to dispose, this is your guy!
                  // controller.dispose();
                },
              ),
            ),
            SizedBox(
              height: titleHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: letterWidth,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 1900),
                      text: ["2"],
                      textStyle: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 242, 177, 121),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: letterWidth,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 1950),
                      text: ["0"],
                      textStyle: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 246, 95, 64),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: letterWidth,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 2000),
                      text: ["4"],
                      textStyle: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 237, 203, 103),
                      ),
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                  SizedBox(
                    width: letterWidth,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 2050),
                      text: ["8"],
                      textStyle: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 232, 192, 70),
                      ),
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                  SizedBox(
                    width: letterWidth,
                    child: RotateAnimatedTextKit(
                      repeatForever: true,
                      duration: Duration(milliseconds: 2100),
                      text: ["+"],
                      textStyle: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: 'Monofett',
                        color: Color.fromARGB(255, 246, 95, 64),
                      ),
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "S T A R T   G A M E ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: buttonFontSize,
                    color: Colors.yellowAccent,
                    fontFamily: 'PatrickHand',
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GameView()));
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "H O W   T O   P L A Y ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: buttonFontSize,
                    color: Colors.yellowAccent,
                    fontFamily: 'PatrickHand',
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HowToPlay()));
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "A B O U T   U S ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: buttonFontSize,
                    color: Colors.yellowAccent,
                    fontFamily: 'PatrickHand',
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomRight,
                child: Text(
                  'Version 1.0.1',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
