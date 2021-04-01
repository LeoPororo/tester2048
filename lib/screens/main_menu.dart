// TODO: Fix issue related to illegalArgumentException for AdMob
// W/ConnectionTracker(21265): Exception thrown while unbinding
// W/ConnectionTracker(21265): java.lang.IllegalArgumentException: Service not registered: com.google.android.gms.measurement.internal.zzja@2e6d7b1
// Said issue can be ignored:
// https://github.com/firebase/firebase-android-sdk/issues/1662

// TODO: Move constant designs to constants.dart once main menu design is complete

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../admob/ad_manager.dart';
import '../constants.dart';
import 'game_view.dart';

class MainMenuWidget extends StatefulWidget {
  @override
  _MainMenuWidgetState createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  BannerAd _bannerAd;

  Future<void> _initAdMob() {
    print("LOADING...");
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top, anchorOffset: getAnchorValue());
  }

  double getAnchorValue() {
    var height = MediaQuery.of(context).size.height;
    print(height);
    if (height > 700)
      return 50;

    return 25;
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
  }

  @protected
  @mustCallSuper
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadBannerAd();

    return Scaffold(
      body: Container(
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
}
