// TODO: Fix issue related to illegalArgumentException for AdMob
// W/ConnectionTracker(21265): Exception thrown while unbinding
// W/ConnectionTracker(21265): java.lang.IllegalArgumentException: Service not registered: com.google.android.gms.measurement.internal.zzja@2e6d7b1
// Said issue can be ignored:
// https://github.com/firebase/firebase-android-sdk/issues/1662

// TODO: Move constant designs to constants.dart once main menu design is complete

import 'dart:io' show Platform;

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../constants.dart';
import 'game_view.dart';

class MainMenuWidget extends StatefulWidget {
  @override
  _MainMenuWidgetState createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;

  @override
  void initState() {
    super.initState();

    bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: tan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: AdmobBanner(
                adUnitId: AdmobBanner.testAdUnitId,
                adSize: bannerSize,
                listener: (AdmobAdEvent event,
                    Map<String, dynamic> args) {
                  handleEvent(event, args, 'Banner');
                },
                onBannerCreated:
                    (AdmobBannerController controller) {
                  // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                  // Normally you don't need to worry about disposing this yourself, it's handled.
                  // If you need direct access to dispose, this is your guy!
                  // controller.dispose();
                },
              ),
            ),
            SizedBox(
              height: 290.0,
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
                        fontWeight: FontWeight.bold,
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
            ElevatedButton(
              style: buttonStyle,
              child: Container(
                width: 270.0,
                height: 60.0,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "S T A R T   G A M E ",
                  textAlign: TextAlign.center,
                  style: mainMenuTextStyle,
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
                width: 270.0,
                height: 60.0,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "H O W   T O   P L A Y ",
                  textAlign: TextAlign.center,
                  style: mainMenuTextStyle,
                ),
              ),
              onPressed: () {},
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: Container(
                width: 270.0,
                height: 60.0,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "A B O U T   U S ",
                  textAlign: TextAlign.center,
                  style: mainMenuTextStyle,
                ),
              ),
              onPressed: () {},
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              SizedBox(
                height: 78.0,
              ),
              Text('Version 1.0.0',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  )),
            ]),
          ],
        ),
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8865242552';
    }
    return null;
  }
}
