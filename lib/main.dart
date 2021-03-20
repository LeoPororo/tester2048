import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'progressbar_painter.dart';
import 'enums/action_mode.dart';
import 'enums/operator_mode.dart';
import 'enums/visibility_mode.dart';
import 'tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: Home2048(),
    );
  }
}

class Home2048 extends StatefulWidget {
  @override
  _Home2048State createState() => _Home2048State();
}

class _Home2048State extends State<Home2048>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  int counter = 10;
  AnimationController controller;

  List<Tile> toAdd = [];
  List<int> toShuffle = [];
  List<List<Tile>> grid =
  List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0)));
  Iterable<List<Tile>> get cols =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));
  Iterable<Tile> get flattenedGrid => grid.expand((e) => e);

  int tapCounter = 0;
  //used to determine the number of taps
  int tapOne = 0;
  double xTapOne = 0;
  double yTapOne = 0;
  //used to save the values of the first tap
  int tapTwo = 0;
  double xTapTwo = 0;
  double yTapTwo = 0;
  //used to save the values of the second tap

  VisibilityMode visibilityMode = VisibilityMode.NUMBERED;
  ActionMode actionMode = ActionMode.SWIPE;
  OperatorMode operatorMode = OperatorMode.ADD;
  bool tileCheck = false; // used to determine the number of tiles to be added
  bool isTimerOn = false;


  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          toAdd.forEach((element) {
            grid[element.y][element.x].val = element.val;
          });
          flattenedGrid.forEach((element) => element.resetAnimations());
          toAdd.clear();
        });
      }
    });

    restartGame();
  }

  @override
  Widget build(BuildContext context) {
    double gridSize = MediaQuery.of(context).size.width - 16.0 * 2;
    double tileSize = (gridSize - 4.0 * 2) / 4;
    List<Widget> stackItems = [];
    stackItems.addAll(
      flattenedGrid.map(
        (e) => Positioned(
          left: e.x * tileSize,
          top: e.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: GestureDetector(
              onTap: () {
                print("Tapped No tile: (" +
                    e.x.toString() +
                    "," +
                    e.y.toString() +
                    ")");
                //
                // y x 0 1 2 3
                // 0  [a,b,c,d]
                // 1  [e,f,g,h]
                // 2  [i,j,k,l]
                // 3  [m,n,o,p]
                //
              },
              child: Container(
                width: tileSize - 4.0 * 2,
                height: tileSize - 4.0 * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: lightBrown,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    stackItems.addAll(
      [flattenedGrid, toAdd].expand((tile) => tile).map(
            (tile) => AnimatedBuilder(
              animation: controller,
              builder: (context, child) => tile.animatedValue.value == 0
                  ? SizedBox()
                  : Positioned(
                      left: tile.animatedX.value * tileSize,
                      top: tile.animatedY.value * tileSize,
                      width: tileSize,
                      height: tileSize,
                      child: Center(
                        child: Container(
                          width: (tileSize - 4.0 * 2) * tile.scale.value,
                          height: (tileSize - 4.0 * 2) * tile.scale.value,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: visibilityMode == VisibilityMode.NUMBERED
                                  ? numTileColor[tile.animatedValue.value]
                                  : tan),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: ensure that tap is only enabled when mode is tap
                              // TODO: Store tile position to a variable as tap #1 then the other number to tap #2.
                              // then if this is the tap #2 (second tap), check for the values if they are the same (tap #1 and tap #2) using stackItems.
                              // You can loop the stack items then check for their values.
                              // Value is stored in Tile class val variable
                              if (actionMode == ActionMode.TAP) {
                                if (tapCounter != 2) {
                                  tapCounter == 0
                                      ? tapOne = tile.animatedValue.value
                                      : tapTwo = tile.animatedValue.value;
                                  tapCounter == 0
                                      ? xTapOne = tile.animatedX.value
                                      : xTapTwo = tile.animatedX.value;
                                  tapCounter == 0
                                      ? yTapOne = tile.animatedY.value
                                      : yTapTwo = tile.animatedY.value;

                                  if (tapOne == tapTwo &&
                                      (xTapOne != xTapTwo ||
                                          yTapOne != yTapTwo)) {
                                    print(" IT'S A MATCH! ");
                                    // change this to set the value of the first tap to 0
                                    toAdd.add(Tile(
                                        xTapOne.toInt(), yTapOne.toInt(), 0)
                                      ..appear(controller));
                                    //change this to set the value of the second tapped value
                                    toAdd.add(Tile(xTapTwo.toInt(),
                                        yTapTwo.toInt(), tapOne * 2)
                                      ..appear(controller));
                                  }
                                  print(tapOne.toString() +
                                      "and" +
                                      tapTwo.toString());
                                  print(xTapOne.toString() +
                                      "  " +
                                      yTapOne.toString() +
                                      "  " +
                                      xTapTwo.toString() +
                                      "  " +
                                      yTapTwo.toString() +
                                      "  ");
                                  print(
                                      "Tap Counter: " + tapCounter.toString());
                                  tapCounter++;
                                } else {
                                  print(
                                      "Tap Counter: " + tapCounter.toString());
                                  print("RESET!");
                                  resetTapTrackers();
                                }
                                //
                                // print("Values: " +
                                //     tile.animatedX.value.toString() +
                                //     "," +
                                //     tile.animatedY.value.toString() +
                                //     "," +
                                //     tile.animatedValue.value.toString());
                              }
                              setState(() {});
                            },
                            child: Center(
                              child: visibilityMode == VisibilityMode.NUMBERED
                                  ? Text(
                                      '${tile.animatedValue.value}',
                                      style: TextStyle(
                                        color: tile.animatedValue.value <= 4
                                            ? greyText
                                            : Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'assets/question.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
    );

    return Scaffold(
      backgroundColor: tan,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    child: Text(
                      describeEnum(visibilityMode) == "NUMBERED" ? "BLOCKED" : "NUMBERED",
                      style: TextStyle(
                        color: buttonText,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPressed: changeVisibilityMode,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    child: Text(
                      describeEnum(actionMode) == "SWIPE" ? "TAP" : "SWIPE",
                      style: TextStyle(
                        color: buttonText,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPressed: changeActionMode,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    child: Text(
                      describeEnum(operatorMode) == "ADD" ? "MINUS" : "ADD",
                      style: TextStyle(
                        color: buttonText,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPressed: changeOperatorMode,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    child: Text(
                      "SHUFFLE",
                      style: TextStyle(
                        color: buttonText,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        flattenedGrid.forEach((e) {
                          e.val = 0;
                          e.resetAnimations();
                        });
                        toAdd.clear();
                        addNewTile(toShuffle);
                        controller.forward(from: 0);
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: actionMode == ActionMode.SWIPE
                  ? GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dy < 1 && canSwipeUp()) {
                          doSwipe(swipeUp);
                        } else if (details.velocity.pixelsPerSecond.dy > 1 && canSwipeDown()) {
                          doSwipe(swipeDown);
                        }
                      },
                      onHorizontalDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx < 1 && canSwipeLeft()) {
                          doSwipe(swipeLeft);
                        } else if (details.velocity.pixelsPerSecond.dx > 1 && canSwipeRight()) {
                          doSwipe(swipeRight);
                        }
                      },
                      child: Stack(
                        children: stackItems,
                      ),
                    )
                  : GestureDetector(
//                      onTap: () {
//                        print('Tapped');
//                      },
                      child: Stack(
                        children: stackItems,
                      ),
                    ),
              width: gridSize,
              height: gridSize,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: darkBrown,
              ),
            ),
            Container(
              width: 400,
              child: CustomPaint(
                size: Size(10, 10),
                painter: ProgressBarPainter(progressBarValue: counter, state: isTimerOn),
              ),
            ),
            Container(
              height: 80,
              width: 400,
              child: ElevatedButton(
                style: buttonStyle,
                child: Text(
                  "Restart",
                  style: TextStyle(
                    color: buttonText,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: restartGame,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNewTile(List<int> newTiles) {
    List<Tile> empty = flattenedGrid.where((e) => e.val == 0).toList();
    empty.shuffle();
    for (int i = 0; i < newTiles.length; i++) {
      toAdd.add(Tile(empty[i].x, empty[i].y, newTiles[i])..appear(controller));
      // print('Indexes: x = ${empty[i].x} and y = ${empty[i].y}');
    }
  }

  void decreasingProgressBar() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          _timer.cancel();
          counter = 10;
          restartGame();
        }
      });
    });
  }

  void doSwipe(void Function() swipeFn) {
    setState(() {
      swipeFn();
      tileCheck ? addNewTile([2, 2, 2]) : addNewTile([2]);
      toShuffle.clear();
      tileChecker();
      print(toShuffle);
      controller.forward(from: 0);
    });
  }

  bool canSwipeLeft() => grid.any(canSwipe);
  bool canSwipeRight() => grid.map((e) => e.reversed.toList()).any(canSwipe);
  bool canSwipeUp() => cols.any(canSwipe);
  bool canSwipeDown() => cols.map((e) => e.reversed.toList()).any(canSwipe);
  bool canSwipe(List<Tile> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].val == 0) {
        if (tiles.skip(i + 1).any((e) => e.val != 0)) {
          return true;
        }
      } else {
        Tile nextNonZero =
            tiles.skip(i + 1).firstWhere((e) => e.val != 0, orElse: () => null);
        if (nextNonZero != null && nextNonZero.val == tiles[i].val) {
          return true;
        }
      }
    }
    return false;
  }

  void swipeLeft() => grid.forEach(mergeTiles);
  void swipeRight() => grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void swipeUp() => cols.forEach(mergeTiles);
  void swipeDown() => cols.map((e) => e.reversed.toList()).forEach(mergeTiles);

  void mergeTiles(List<Tile> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      Iterable<Tile> toCheck =
          tiles.skip(i).skipWhile((value) => value.val == 0);
      if (toCheck.isNotEmpty) {
        Tile t = toCheck.first;
        Tile merge =
            toCheck.skip(1).firstWhere((t) => t.val != 0, orElse: () => null);
        if (merge != null && merge.val != t.val) {
          merge = null;
        }
        if (tiles[i] != t || merge != null) {
          int resultValue = t.val;
          t.moveTo(controller, tiles[i].x, tiles[i].y);
          if (merge != null) {
            double divisionResult;
            divisionResult = resultValue / 2;
            operatorMode == OperatorMode.ADD
                ? resultValue += merge.val
                : resultValue = divisionResult.toInt();
            if (resultValue == 1) {
              resultValue = 0;
              tileCheck = true;
            } else {
              tileCheck = false;
            }
            merge.moveTo(controller, tiles[i].x, tiles[i].y);
            merge.bounce(controller);
            merge.changeNumber(controller, resultValue);
            merge.val = 0;
            t.changeNumber(controller, 0);
          }
          t.val = 0;
          tiles[i].val = resultValue;
        }
      }
    }
  }

  void tileChecker() {
    flattenedGrid.forEach((e) {
      e.val != 0 ? toShuffle.add(e.val) : toShuffle.add(0);
    });

    int length;
    tileCheck ? length = 3 : length = 1;
    for (int i = 0; i < length; i++) {
      for (int i = 0; i < toShuffle.length; i++) {
        if (toShuffle[i] == 0) {
          toShuffle[i] = 2;
          i = toShuffle.length;
        }
      }
    }
  }

  void restartGame() {
    setState(() {
      flattenedGrid.forEach((e) {
        e.val = 0;
        e.resetAnimations();
      });
      toAdd.clear();
      addNewTile([2, 2]);
      controller.forward(from: 0);
      counter = 10;
      visibilityMode = VisibilityMode.NUMBERED;
      actionMode = ActionMode.SWIPE;
      operatorMode = OperatorMode.ADD;
      tileCheck = false;

      if (isTimerOn){
        decreasingProgressBar();
      }
    });
  }

  void changeVisibilityMode() {
    setState(() {
      visibilityMode == VisibilityMode.NUMBERED
          ? visibilityMode = VisibilityMode.BLOCKED
          : visibilityMode = VisibilityMode.NUMBERED;
      print("Visibility Mode: $visibilityMode");
    });
  }

  void changeActionMode() {
    setState(() {
      actionMode == ActionMode.TAP
          ? actionMode = ActionMode.SWIPE
          : actionMode = ActionMode.TAP;
      resetTapTrackers();
      print("Action Mode: $actionMode");
    });
  }

  void changeOperatorMode() {
    setState(() {
      operatorMode == OperatorMode.ADD
          ? operatorMode = OperatorMode.MINUS
          : operatorMode = OperatorMode.ADD;
      print("Operator Mode: $operatorMode");
    });
  }

  void resetTapTrackers() {
    tapCounter = 0;
    tapOne = 0;
    xTapOne = 0;
    yTapOne = 0;
    tapTwo = 0;
    xTapTwo = 0;
    yTapTwo = 0;
  }
}
