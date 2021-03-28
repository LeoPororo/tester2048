import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'progressbar_painter.dart';
import 'enums/action_mode.dart';
import 'enums/operator_mode.dart';
import 'enums/visibility_mode.dart';
import 'tile.dart';
import 'screens/main_menu.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: MainMenuWidget(),
    );
  }
}

