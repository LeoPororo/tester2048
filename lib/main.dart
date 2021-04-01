import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twentyfourtyeightplus/screens/about_us.dart';

import 'package:admob_flutter/admob_flutter.dart';

import 'screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048+',
      home: MainMenuWidget(),
    );
  }
}
