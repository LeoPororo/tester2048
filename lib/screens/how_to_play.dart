import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twentyfourtyeightplus/admob/ad_manager.dart';
import 'package:twentyfourtyeightplus/constants.dart';

class HowToPlay extends StatefulWidget {
  @override
  _HowToPlayState createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: tan,
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: AdmobBanner(
                      adUnitId: AdManager.bannerByUsage("HOW_TO_PLAY"),
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
                )
              ],
            ),
            Image(image: AssetImage('images/final_howtoplay.png')),
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
