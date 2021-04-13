import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:twentyfourtyeightplus/admob/ad_manager.dart';
import 'package:twentyfourtyeightplus/constants.dart';
import 'dart:async';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AdmobBannerSize bannerSize;
  double _spaceHeight = 100;
  int _counter = 2;
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
    bannerSize = AdmobBannerSize.BANNER;
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var topBearLeft = 250.0;
    var paragraphLeft = 10.0;
    var paragraphFontSize = 17.0;
    var paragraphConstraintWidth = width - 16 * 2;
    var visibleBottomBear = true;

    // BUTTONS
    var buttonFontSize = 30.0;
    var buttonWidth = 270.0;
    var buttonHeight = 60.0;

    if (width > 600) {
      topBearLeft = 550.0;
      paragraphLeft = 20.0;
      paragraphFontSize = 36.0;
      buttonFontSize = 50.0;
      buttonWidth = 450.0;
      buttonHeight = 90.0;
    }
    else if (width > 500) {
      topBearLeft = 450.0;
      paragraphLeft = 10.0;
      paragraphFontSize = 30.0;
      buttonFontSize = 50.0;
      buttonWidth = 450.0;
      buttonHeight = 90.0;
    }
    else if (width < 400){
      topBearLeft = 180.0;
      paragraphLeft = 5.0;
      paragraphFontSize = 12.0;
      visibleBottomBear = false;
    }

    return SafeArea(
      child: Material(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: tan,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: AdmobBanner(
                  adUnitId: AdManager.bannerByUsage("ABOUT_US"),
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
                height: 5.0,
              ),
              Container(
                width: buttonWidth,
                height: buttonHeight,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: buttonBg,
                ),
                child: Text(
                  " A B O U T   U S ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: buttonFontSize,
                    color: Colors.yellowAccent,
                    fontFamily: 'PatrickHand',
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 5.0,
                      left: topBearLeft,
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
                      left: paragraphLeft,
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
                            fontSize: paragraphFontSize,
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: paragraphConstraintWidth),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visibleBottomBear,
                child: Image(
                  image: AssetImage('images/honey_bear.png'),
                  height: 110.0,
                ),
              ),
              ElevatedButton(
                style: buttonStyle,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "B A C K",
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
