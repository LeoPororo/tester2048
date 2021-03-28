// TODO: move constants to constants.dart file
// TODO: how visibility works
// Pointing system:
// If the mode is ADD the value will be the merged value.
// Example: 2 and 2. 2 + 2. it will be 4 points
//          16 and 16. 16 + 16. it will be 32 points
// If the mode is MINUS the value will be half of the merged value
// Example: 2 and 2. 4 / 2. it will be 2 points
//          8 and 8. 16 / 2. it will be 8 points

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../enums/action_mode.dart';
import '../enums/operator_mode.dart';
import '../enums/visibility_mode.dart';
import '../constants.dart';
import '../progressbar_painter.dart';
import '../tile.dart';

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  // TODO: Fix naming convention. private should have _ at the start of their names
  Timer _progressBarTimer;
  int _progressBarCounter = maxTimerInSeconds;

  Timer _readySetTimer;
  int _readyCounter = 0;

  Timer _changeModeTimer;
  int _changeModeCounter = 0;
  String _currentMode = "-";

  AnimationController controller;

  int _highestValueTile = 0;

  int _boardSize = 4;
  List<Tile> toAdd = [];
  List<int> toShuffle = [];
  List<List<Tile>> grid =
  List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0, 1.0)));
  Iterable<List<Tile>> get cols {
    return List.generate(
        _boardSize, (x) => List.generate(_boardSize, (y) => grid[y][x]));
  }

  Iterable<Tile> get flattenedGrid => grid.expand((e) => e);

  int tapCounter = 0;
  int addSeconds = 0;
  Tile tapTileOne, tapTileTwo;

  VisibilityMode visibilityMode = VisibilityMode.NUMBERED;
  ActionMode actionMode = ActionMode.SWIPE;
  OperatorMode operatorMode = OperatorMode.ADD;
  bool isTimerOn = true;
  bool isTestingOn = false;
  bool isReady = false;
  bool _increaseBoardSizeEnabled = false;
  bool _shouldIncreaseBoardSize = false;

  List<String> readySetStrings = ["READY", "SET", "GO!!!", ""];

  int _score = 0;
  int _highScore = 0;

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

          _progressBarCounter += addSeconds;
          if (_progressBarCounter > maxTimerInSeconds)
            _progressBarCounter = maxTimerInSeconds;
          addSeconds = 0;
        });
      }
    });
    startReadySetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tan,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: setupGameView(),
        ),
      ),
    );
  }

  List<Widget> setupGameView() {
    double gridSize = MediaQuery.of(context).size.width - 16.0 * 2;
    double tileSize = (gridSize - 4.0 * 2) / _boardSize;

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
              onTap: () => onEmptyTileTap(e),
              child: Container(
                width: tileSize - _boardSize * 2,
                height: tileSize - _boardSize * 2,
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
              child: GestureDetector(
                onTap: () => onNumberedTileTap(tile),
                child: Container(
                  width:
                  (tileSize - _boardSize * 2) * tile.scale.value,
                  height:
                  (tileSize - _boardSize * 2) * tile.scale.value,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: getNumberedTileColor(tile, false)),
                  child: Center(
                    child: visibilityMode == VisibilityMode.NUMBERED
                        ? Text(
                      '${tile.animatedValue.value}',
                      style: TextStyle(
                        color: getNumberedTileTextColor(
                            tile, false),
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

    return <Widget>[
      isTestingOn
          ? Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: buttonStyle,
              child: Text(
                describeEnum(visibilityMode) == "NUMBERED"
                    ? "BLOCKED"
                    : "NUMBERED",
                style: textStyleSize10FontWeight800,
              ),
              onPressed: changeVisibilityMode,
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: buttonStyle,
              child: Text(
                describeEnum(actionMode) == "SWIPE" ? "TAP" : "SWIPE",
                style: textStyleSize10FontWeight800,
              ),
              onPressed: () => changeActionMode(null),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: buttonStyle,
              child: Text(
                describeEnum(operatorMode) == "ADD" ? "MINUS" : "ADD",
                style: textStyleSize10FontWeight800,
              ),
              onPressed: () => changeOperatorMode(null),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: buttonStyle,
              child: Text(
                "SHUFFLE",
                style: textStyleSize10FontWeight800,
              ),
              onPressed: doShuffle,
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text("MODE", style: textStyleSize21FontWeight900),
                  Text("$_currentMode",
                      style: textStyleSize21FontWeight900),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text("Score: $_score",
                      style: textStyleSize21FontWeight900),
                  Text("High Score: $_highScore",
                      style: textStyleSize21FontWeight900),
                ],
              ),
            ),
          )
        ],
      ),
      Stack(
        children: <Widget>[
          Container(
            child: actionMode == ActionMode.SWIPE
                ? GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < 1 &&
                    canSwipeUp()) {
                  doSwipe(swipeUp);
                } else if (details.velocity.pixelsPerSecond.dy > 1 &&
                    canSwipeDown()) {
                  doSwipe(swipeDown);
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx < 1 &&
                    canSwipeLeft()) {
                  doSwipe(swipeLeft);
                } else if (details.velocity.pixelsPerSecond.dx > 1 &&
                    canSwipeRight()) {
                  doSwipe(swipeRight);
                }
              },
              child: Stack(
                children: stackItems,
              ),
            )
                : GestureDetector(
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
            width: gridSize,
            height: gridSize,
            padding: EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: Text(
                    readySetStrings[_readyCounter],
                    key: ValueKey<int>(_readyCounter),
                    style: TextStyle(
                        fontSize: 50,
                        color: greyText,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      Container(
        width: 400,
        child: CustomPaint(
          size: Size(10, 10),
          painter: ProgressBarPainter(
              progressBarValue: _progressBarCounter, state: isTimerOn),
        ),
      ),
      Container(
        height: 80,
        width: 400,
        child: ElevatedButton(
          style: buttonStyle,
          child: Text(
            "Restart",
            style: textStyleSize34FontWeight800,
          ),
          onPressed: () {
            setState(() {
              _readyCounter = 0;
              _progressBarTimer.cancel();
              _changeModeTimer.cancel();
              startReadySetTimer();
            });
          },
        ),
      ),
    ];
  }

  void addNewTile(List<int> newTiles) {
    List<Tile> empty = flattenedGrid.where((e) => e.val == 0).toList();
    empty.shuffle();
    bool canAddAll = empty.length >= newTiles.length;
    int maxCount = newTiles.length;
    if (!canAddAll) {
      maxCount = empty.length;
    }
    for (int i = 0; i < maxCount; i++) {
      toAdd.add(
          Tile(empty[i].x, empty[i].y, newTiles[i], 1.0)..appear(controller));
    }
  }

  void startReadySetTimer() {
    // TODO: Add sounds per increment
    if (_readySetTimer != null) {
      _readySetTimer.cancel();
    }
    _readySetTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_readyCounter == readySetStrings.length - 2) {
          _readySetTimer.cancel();
          restartGame();
        }

        _readyCounter += 1;
      });
    });
  }

  void startChangeModeTimer() {
    // TODO: Add sounds when changing modes
    if (_changeModeTimer != null) {
      _changeModeTimer.cancel();
    }
    _changeModeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _changeModeCounter += 1;

        if (_changeModeCounter == maxChangeModeTimerInSeconds) {
          setRandomMode();
          _changeModeCounter = 0;
        }
      });
    });
  }

  void startProgressBarTimer() {
    if (_progressBarTimer != null) {
      _progressBarTimer.cancel();
    }
    _progressBarTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_progressBarCounter > 0) {
          _progressBarCounter--;
        } else {
          _progressBarTimer.cancel();
          _progressBarCounter = maxTimerInSeconds;
          _readyCounter = 0;
          startReadySetTimer();
        }
      });
    });
  }

  void doSwipe(void Function() swipeFn) {
    // TODO: Add sounds for successful swipes.
    setState(() {
      swipeFn();
      if (toAdd.length == 0) addNewTile([2]);
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
            int scoreToAdd = resultValue;

            if (resultValue == 1) {
              resultValue = 0;
              merge.moveTo(controller, tiles[i].x, tiles[i].y);
              merge.disappear(controller);
              t.disappear(controller);
              merge.val = 0;

              if (toAdd.length == 0) addNewTile([2, _highestValueTile]);
            } else {
              merge.moveTo(controller, tiles[i].x, tiles[i].y);
              merge.bounce(controller);
              merge.changeNumber(controller, resultValue);

              merge.val = 0;
              t.changeNumber(controller, 0);
            }
            addSeconds += 1;

            setScore(scoreToAdd, t.val);
          }
          t.val = 0;
          tiles[i].val = resultValue;
          tileValueChecker();
        }
      }
    }
  }

  void restartGame() {
    setState(() {
      if (_increaseBoardSizeEnabled && _shouldIncreaseBoardSize) {
        _boardSize += 1;
        if (_boardSize > 5) _boardSize = 10;
      }

      grid = List.generate(_boardSize,
              (y) => List.generate(_boardSize, (x) => Tile(x, y, 0, 1.0)));

      flattenedGrid.forEach((e) {
        e.val = 0;
        e.resetAnimations();
      });

      _score = 0;

      toAdd.clear();
      addNewTile([2, 2]);
      controller.forward(from: 0);
      _progressBarCounter = maxTimerInSeconds;
      _changeModeCounter = 0;
      _highestValueTile = 0;
      visibilityMode = VisibilityMode.NUMBERED;
      actionMode = ActionMode.SWIPE;
      operatorMode = OperatorMode.ADD;
      setModeDescription();
      if (isTimerOn) {
        startProgressBarTimer();
        startChangeModeTimer();
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

  void changeActionMode(ActionMode newAction) {
    setState(() {
      // Passing null is for test purposes only
      if (newAction == null) {
        actionMode == ActionMode.TAP
            ? actionMode = ActionMode.SWIPE
            : actionMode = ActionMode.TAP;
        print("Action Mode: $actionMode");
      } else {
        actionMode = newAction;
        print("Action Mode: $actionMode");
      }
    });
  }

  void changeOperatorMode(OperatorMode newOperator) {
    setState(() {
      // Passing null is for test purposes only
      if (newOperator == null) {
        operatorMode == OperatorMode.ADD
            ? operatorMode = OperatorMode.MINUS
            : operatorMode = OperatorMode.ADD;
        print("Operator Mode: $operatorMode");
      } else {
        operatorMode = newOperator;
        print("Operator Mode: $operatorMode");
      }
    });
  }

  void tileValueChecker() {
    setState(() {
      List<Tile> tileCheck = flattenedGrid.where((e) => e.val != 0).toList();
      for (int i = 0; i < tileCheck.length; i++) {
        if (tileCheck[i].val > _highestValueTile) {
          _highestValueTile = tileCheck[i].val;
        }
      }
    });
  }

  void doShuffle() {
    setState(() {
      List<Tile> notZeroTiles = flattenedGrid.where((e) => e.val != 0).toList();
      List<String> indexes = [];
      var index;
      var x, y;
      for (int i = 0; i < notZeroTiles.length; i++) {
        do {
          x = new Random().nextInt(_boardSize);
          y = new Random().nextInt(_boardSize);
          index = "$x$y";

          if (!indexes.contains(index.toString())) {
            indexes.add(index.toString());
            break;
          }
        } while (true);

        toAdd.add(Tile(x, y, notZeroTiles[i].val, 1.0)..appear(controller));
      }

      flattenedGrid.forEach((e) {
        e.val = 0;
        e.resetAnimations();
      });
      controller.forward(from: 0);
    });
  }

  void onEmptyTileTap(Tile tile) {
    setState(() {
      if (tapCounter == 1) {
        tapTileOne.untap(controller);
        tapTileOne.resetAnimations();
        tapTileOne.s = 1.0;
        controller.forward(from: 0);
      }
      tapCounter = 0;
      tapTileOne = null;
      tapTileTwo = null;
    });
  }

  void onNumberedTileTap(Tile tile) {
    if (actionMode == ActionMode.TAP && !controller.isAnimating) {
      if (tapCounter != 2) {
        if (tapCounter == 0) {
          tapTileOne = tile;
          tapTileOne.resetAnimations();
          tapTileOne.tap(controller);
          tapTileOne.s = 1.2;
          controller.forward(from: 0);
        } else {
          tapTileTwo = tile;
        }

        if (tapCounter == 1) {
          if (tapTileOne.val == tapTileTwo.val &&
              !tapTileOne.isSame(tapTileTwo)) {
            int scoreToAdd = tapTileOne.val;
            int multiplier = 1;

            tapTileOne.s = 1.0;
            tapTileOne.changeNumber(controller, 0);
            tapTileOne.val = 0;

            if (operatorMode == OperatorMode.ADD) {
              tapTileTwo.bounce(controller);
              tapTileTwo.changeNumber(controller, tapTileTwo.val * 2);
              tapTileTwo.val = tapTileTwo.val * 2;
              addNewTile([2, 2]);
              multiplier = 2;
              setScore(scoreToAdd, multiplier, true);
            } else {
              multiplier = tapTileTwo.val;
              tapTileTwo.disappear(controller);
              double decreasedValue = tapTileTwo.val / 2;
              if (decreasedValue == 1) {
                tapTileTwo.changeNumber(controller, 0);
                tapTileTwo.val = 0;
                scoreToAdd = decreasedValue.toInt();
              } else {
                scoreToAdd = 1;
                tapTileTwo.changeNumber(controller, decreasedValue.toInt());
                tapTileTwo.val = decreasedValue.toInt();
              }

              addNewTile([2, _highestValueTile]);
              setScore(scoreToAdd, multiplier);
            }

            tapTileOne.moveTo(controller, tapTileTwo.x, tapTileTwo.y);

            addSeconds = 1;
            controller.forward(from: 0);

            tapTileOne = null;
            tapTileTwo = null;
          } else {
            tapTileOne.s = 1.0;
            tapTileOne.resetAnimations();
            controller.forward(from: 0);
          }
        }

        tapCounter++;
        if (tapCounter == 2) tapCounter = 0;
        tileValueChecker();
      }
    }
  }

  Color getNumberedTileColor(Tile tile, bool reverseTextAndTileColor) {
    Color color = tan;

    if (visibilityMode == VisibilityMode.NUMBERED)
      color = numTileColor[tile.animatedValue.value];

    if (actionMode == ActionMode.TAP && !reverseTextAndTileColor) {
      return getNumberedTileTextColor(tile, true);
    }

    return color;
  }

  Color getNumberedTileTextColor(Tile tile, bool reverseTextAndTileColor) {
    Color color = Colors.white;
    if (tile.animatedValue.value <= 4) color = greyText;
    if (actionMode == ActionMode.TAP && !reverseTextAndTileColor) {
      return getNumberedTileColor(tile, true);
    }

    return color;
  }

  void setRandomMode() {
    addSeconds = 0;
    tapCounter = 0;
    if (tapTileOne != null) {
      tapTileOne.untap(controller);
      tapTileOne.resetAnimations();
      tapTileOne.s = 1.0;
      controller.forward(from: 0);
    }
    tapTileOne = null;
    tapTileTwo = null;

    var actions = [ActionMode.TAP, ActionMode.SWIPE];
    var operators = [OperatorMode.ADD, OperatorMode.MINUS];
    var isSameMode = true;
    var newAction, newOperator;

    do {
      newAction = actions[new Random().nextInt(actions.length)];
      newOperator = operators[new Random().nextInt(operators.length)];

      if (newAction != actionMode || newOperator != operatorMode) {
        isSameMode = false;
        break;
      }
    } while (isSameMode);

    changeActionMode(newAction);
    changeOperatorMode(newOperator);

    setModeDescription();
  }

  void setModeDescription() {
    var actionDesc = describeEnum(actionMode);
    var operatorDesc = describeEnum(operatorMode);
    _currentMode = "$actionDesc - $operatorDesc";
  }

  void setScore(int additionalScore,
      [int multiplier = 1, bool forceMultiply = false]) {
    // TODO: Save high score
    if (additionalScore == 0) return;

    if (additionalScore == 1 || forceMultiply)
      _score += additionalScore * multiplier;
    else
      _score += additionalScore;

    // TODO: Add required score in order to increase the board
    if (_score > 10) {
      _shouldIncreaseBoardSize = true;
    }

    if (_score > _highScore) {
      _highScore = _score;
    }
  }
}
