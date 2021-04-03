import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3259383160721715~3478552105";
    }  else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitIdMainMenu {
    if (Platform.isAndroid) {
      return "ca-app-pub-3259383160721715/1945978586";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitIdGameView {
    if (Platform.isAndroid) {
      return "ca-app-pub-3259383160721715/4104613340";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitIdAboutUs {
    if (Platform.isAndroid) {
      return "ca-app-pub-3259383160721715/5713208484";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitIdHowToPlay {
    if (Platform.isAndroid) {
      return "ca-app-pub-3259383160721715/6539204997";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
      default:
    }
  }

}