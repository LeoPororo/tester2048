import 'package:flutter/material.dart';

class Tile {
  final int x;
  final int y;
  int val;
  double s;

  Animation<double> animatedX;
  Animation<double> animatedY;
  Animation<int> animatedValue;
  Animation<double> scale;

  Tile(this.x, this.y, this.val, this.s) {
    resetAnimations();
  }

  void resetAnimations() {
    animatedX = AlwaysStoppedAnimation(this.x.toDouble());
    animatedY = AlwaysStoppedAnimation(this.y.toDouble());
    animatedValue = AlwaysStoppedAnimation(this.val);
    scale = AlwaysStoppedAnimation(s);
  }

  void moveTo(Animation<double> parent, int x, int y) {
    animatedX = Tween(begin: this.x.toDouble(), end: x.toDouble())
        .animate(CurvedAnimation(parent: parent, curve: Interval(0, .5)));
    animatedY = Tween(begin: this.y.toDouble(), end: y.toDouble())
        .animate(CurvedAnimation(parent: parent, curve: Interval(0, .5)));
  }

  void bounce(Animation<double> parent) {
    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1.0),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(.5, 1.0)));
  }

  void appear(Animation<double> parent) {
    scale = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: parent, curve: Interval(0.0, 1.0)));
  }

  void disappear(Animation<double> parent) {
    scale = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1.0)));
  }

  void changeNumber(Animation<double> parent, int newValue) {
    // TODO: Know how Animation works in flutter
    // TODO: Know why setting val to newValue after this call is not working but it is okay outside method call
    animatedValue = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(val), weight: .01),
      TweenSequenceItem(tween: ConstantTween(val), weight: .99),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1.0)));
  }

  void tap(Animation<double> parent) {
    scale = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: parent, curve: Interval(0.8, 1)));
  }

  void untap(Animation<double> parent) {
    scale = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: parent, curve: Interval(0.8, 1)));
  }

  bool isSame(Tile t)
  {
    return this.x == t.x && this.y == t.y;
  }
}
