import 'dart:async';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admob/ad_manager.dart';
import '../enums/action_mode.dart';
import '../enums/operator_mode.dart';
import '../constants.dart';
import '../progressbar_painter.dart';
import '../tile.dart';

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  var screenWidth;

  static AudioCache player =
      AudioCache(prefix: 'assets/audios/', fixedPlayer: AudioPlayer());

  AdmobBannerSize bannerSize;

  Timer _progressBarTimer;
  int _progressBarCounter = maxTimerInSeconds;

  Timer _readySetTimer;
  int _readyCounter = 0;

  Timer _changeModeTimer;
  int _changeModeCounter = 0;
  String _currentMode = "-";

  AnimationController _controller;

  int _highestValueTile = 0;

  List<Tile> _toAdd = [];
  List<List<Tile>> _grid =
      List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0, 1.0)));
  Iterable<List<Tile>> get _cols {
    return List.generate(
        boardSize, (x) => List.generate(boardSize, (y) => _grid[y][x]));
  }

  Iterable<Tile> get _flattenedGrid => _grid.expand((e) => e);

  int _tapCounter = 0;
  int _addSeconds = 0;
  Tile _tapTileOne, _tapTileTwo;

  ActionMode _actionMode = ActionMode.SWIPE;
  OperatorMode _operatorMode = OperatorMode.ADD;
  bool _isTimerOn = true;

  int _score = 0;
  int _highScore = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();

    player.load(audios["SWIPE"]);
    player.load(audios["TAP"]);

    bannerSize = AdmobBannerSize.BANNER;

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _toAdd.forEach((element) {
            _grid[element.y][element.x].val = element.val;
          });
          _flattenedGrid.forEach((element) => element.resetAnimations());
          _toAdd.clear();

          _progressBarCounter += _addSeconds;
          if (_progressBarCounter > maxTimerInSeconds)
            _progressBarCounter = maxTimerInSeconds;
          _addSeconds = 0;
        });
      }
    });

    loadHighScore();
    startReadySetTimer();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

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
    double tileSize = (gridSize - 4.0 * 2) / boardSize;

    List<Widget> stackItems = [];

    stackItems.addAll(
      _flattenedGrid.map(
        (e) => Positioned(
          left: e.x * tileSize,
          top: e.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: GestureDetector(
              onTap: () => onEmptyTileTap(e),
              child: Container(
                width: tileSize - boardSize * 2,
                height: tileSize - boardSize * 2,
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
      [_flattenedGrid, _toAdd].expand((tile) => tile).map(
            (tile) => AnimatedBuilder(
              animation: _controller,
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
                                (tileSize - boardSize * 2) * tile.scale.value,
                            height:
                                (tileSize - boardSize * 2) * tile.scale.value,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: getNumberedTileColor(tile, false)),
                            child: Center(
                              child: Text(
                                '${tile.animatedValue.value}',
                                style: TextStyle(
                                  color: getNumberedTileTextColor(tile, false),
                                  fontSize: getTileFontSize(tile.animatedValue.value),
                                  fontWeight: FontWeight.w900,
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
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: AdmobBanner(
          adUnitId: AdManager.bannerByUsage("GAME_VIEW"),
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
      Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(
                    "MODE",
                    style: TextStyle(
                      color: greyText,
                      fontSize: getModeFontSize(),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "$_currentMode",
                    style: TextStyle(
                      color: greyText,
                      fontSize: getModeFontSize(),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Score: $_score",
                    style: TextStyle(
                      color: greyText,
                      fontSize: getScoreFontSize(_score),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "High Score: $_highScore",
                    style: TextStyle(
                      color: greyText,
                      fontSize: getScoreFontSize(_highScore),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      Container(
        width: screenWidth - 16 * 2,
        child: CustomPaint(
          size: Size(10, 10),
          painter: ProgressBarPainter(
              progressBarValue: _progressBarCounter,
              state: _isTimerOn,
              screenWidth: screenWidth),
        ),
      ),
      Stack(
        children: <Widget>[
          Container(
            child: _actionMode == ActionMode.SWIPE && !_isGameOver
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
                : Stack(
                    children: stackItems,
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
                        fontSize: getReadySetFontSize(),
                        color: _readyCounter == 4 ? Colors.red : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 80.0,
              child: ElevatedButton(
                style: buttonStyle,
                child: Text(
                  "Restart",
                  style: TextStyle(
                    color: buttonText,
                    fontSize: getButtonFontSize(),
                    fontWeight: FontWeight.w800,
                  ),
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
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              height: 80.0,
              child: ElevatedButton(
                style: buttonStyle,
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: buttonText,
                    fontSize: getButtonFontSize(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    ];
  }

  void addNewTile(List<int> newTiles) {
    List<Tile> empty = _flattenedGrid.where((e) => e.val == 0).toList();
    empty.shuffle();
    bool canAddAll = empty.length >= newTiles.length;
    int maxCount = newTiles.length;
    if (!canAddAll) {
      maxCount = empty.length;
    }
    for (int i = 0; i < maxCount; i++) {
      _toAdd.add(
          Tile(empty[i].x, empty[i].y, newTiles[i], 1.0)..appear(_controller));
    }
  }

  void startReadySetTimer() {
    // TODO: Add sounds per increment
    if (_readySetTimer != null) {
      _readySetTimer.cancel();
    }
    _readySetTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_readyCounter == readySetStrings.length - 3) {
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
          _changeModeTimer.cancel();
          _isGameOver = true;
          _readyCounter++;
          saveHighScore();
        }
      });
    });
  }

  void doSwipe(void Function() swipeFn) {
    // TODO: Add sounds for successful swipes.
    setState(() {
      swipeFn();
      if (_toAdd.length == 0) addNewTile([2]);
      _controller.forward(from: 0);
    });
  }

  bool canSwipeLeft() => _grid.any(canSwipe);
  bool canSwipeRight() => _grid.map((e) => e.reversed.toList()).any(canSwipe);
  bool canSwipeUp() => _cols.any(canSwipe);
  bool canSwipeDown() => _cols.map((e) => e.reversed.toList()).any(canSwipe);
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

  void swipeLeft() => _grid.forEach(mergeTiles);
  void swipeRight() =>
      _grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void swipeUp() => _cols.forEach(mergeTiles);
  void swipeDown() => _cols.map((e) => e.reversed.toList()).forEach(mergeTiles);

  void mergeTiles(List<Tile> tiles) {
    playSwipe("SWIPE");

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
          t.moveTo(_controller, tiles[i].x, tiles[i].y);
          if (merge != null) {
            double divisionResult;
            divisionResult = resultValue / 2;
            _operatorMode == OperatorMode.ADD
                ? resultValue += merge.val
                : resultValue = divisionResult.toInt();
            int scoreToAdd = resultValue;

            if (resultValue == 1) {
              resultValue = 0;
              merge.moveTo(_controller, tiles[i].x, tiles[i].y);
              merge.disappear(_controller);
              t.disappear(_controller);
              merge.val = 0;

              if (_toAdd.length == 0) addNewTile([2]);
            } else {
              merge.moveTo(_controller, tiles[i].x, tiles[i].y);
              merge.bounce(_controller);
              merge.changeNumber(_controller, resultValue);

              merge.val = 0;
              t.changeNumber(_controller, 0);

              if (resultValue > _highestValueTile) {
                _highestValueTile = resultValue;
              }
            }
            _addSeconds += 1;

            setScore(scoreToAdd, t.val);
          }
          t.val = 0;
          tiles[i].val = resultValue;
        }
      }
    }
  }

  void restartGame() {
    setState(() {
      _grid = List.generate(boardSize,
          (y) => List.generate(boardSize, (x) => Tile(x, y, 0, 1.0)));

      _flattenedGrid.forEach((e) {
        e.val = 0;
        e.resetAnimations();
      });

      _toAdd.clear();
      addNewTile([2, 2]);

      _score = 0;
      _isGameOver = false;
      _progressBarCounter = maxTimerInSeconds;
      _changeModeCounter = 0;
      _highestValueTile = 0;

      _controller.forward(from: 0);

      _actionMode = ActionMode.SWIPE;
      _operatorMode = OperatorMode.ADD;
      setModeDescription();

      if (_isTimerOn) {
        startProgressBarTimer();
        startChangeModeTimer();
      }
    });
  }

  void changeActionMode(ActionMode newAction) {
    setState(() {
      _actionMode = newAction;
      print("Action Mode: $_actionMode");
    });
  }

  void changeOperatorMode(OperatorMode newOperator) {
    setState(() {
      _operatorMode = newOperator;
      print("Operator Mode: $_operatorMode");
    });
  }

  void onEmptyTileTap(Tile tile) {
    if (_isGameOver) return;

    setState(() {
      if (_tapCounter == 1) {
        _tapTileOne.untap(_controller);
        _tapTileOne.resetAnimations();
        _tapTileOne.s = 1.0;
        _controller.forward(from: 0);
      }
      _tapCounter = 0;
      _tapTileOne = null;
      _tapTileTwo = null;
    });
  }

  void onNumberedTileTap(Tile tile) {
    if (_actionMode != ActionMode.TAP || _controller.isAnimating || _isGameOver)
      return;

    playSwipe("TAP");

    if (_tapCounter != 2) {
      if (_tapCounter == 0) {
        _tapTileOne = tile;
        _tapTileOne.resetAnimations();
        _tapTileOne.tap(_controller);
        _tapTileOne.s = 1.2;
        _controller.forward(from: 0.8);
      } else {
        _tapTileTwo = tile;
      }

      if (_tapCounter == 1) {
        if (_tapTileOne.val == _tapTileTwo.val &&
            !_tapTileOne.isSame(_tapTileTwo)) {
          int scoreToAdd = _tapTileOne.val;
          int multiplier = 1;

          _tapTileOne.s = 1.0;
          _tapTileOne.changeNumber(_controller, 0);
          _tapTileOne.val = 0;

          if (_operatorMode == OperatorMode.ADD) {
            _tapTileTwo.bounce(_controller);
            _tapTileTwo.changeNumber(_controller, _tapTileTwo.val * 2);
            _tapTileTwo.val = _tapTileTwo.val * 2;
            addNewTile([2, 2]);
            multiplier = 2;
            setScore(scoreToAdd, multiplier, true);

            if (_tapTileTwo.val > _highestValueTile) {
              _highestValueTile = _tapTileTwo.val;
            }
          } else {
            multiplier = _tapTileTwo.val;
            _tapTileTwo.disappear(_controller);
            double decreasedValue = _tapTileTwo.val / 2;
            if (decreasedValue == 1) {
              _tapTileTwo.changeNumber(_controller, 0);
              _tapTileTwo.val = 0;
              scoreToAdd = decreasedValue.toInt();
            } else {
              scoreToAdd = 1;
              _tapTileTwo.changeNumber(_controller, decreasedValue.toInt());
              _tapTileTwo.val = decreasedValue.toInt();
            }

            addNewTile([2, _highestValueTile]);
            setScore(scoreToAdd, multiplier);
          }

          _tapTileOne.moveTo(_controller, _tapTileTwo.x, _tapTileTwo.y);

          _addSeconds = 1;
          _controller.forward(from: 0);

          _tapTileOne = null;
          _tapTileTwo = null;
        } else {
          _tapTileOne.s = 1.0;
          _tapTileOne.resetAnimations();
          _controller.forward(from: 0.8);
        }
      }

      _tapCounter++;
      if (_tapCounter == 2) _tapCounter = 0;
    }
  }

  Color getNumberedTileColor(Tile tile, bool reverseTextAndTileColor) {
    Color color = numTileColor[tile.animatedValue.value];

    if (_actionMode == ActionMode.TAP && !reverseTextAndTileColor) {
      return getNumberedTileTextColor(tile, true);
    }

    return color;
  }

  Color getNumberedTileTextColor(Tile tile, bool reverseTextAndTileColor) {
    Color color = Colors.white;
    if (tile.animatedValue.value <= 4) color = greyText;
    if (_actionMode == ActionMode.TAP && !reverseTextAndTileColor) {
      return getNumberedTileColor(tile, true);
    }

    return color;
  }

  void setRandomMode() {
    _addSeconds = 0;
    _tapCounter = 0;
    if (_tapTileOne != null) {
      _tapTileOne.untap(_controller);
      _tapTileOne.resetAnimations();
      _tapTileOne.s = 1.0;
      _controller.forward(from: 0);
    }
    _tapTileOne = null;
    _tapTileTwo = null;

    var actions = [ActionMode.TAP, ActionMode.SWIPE];
    var operators = [OperatorMode.ADD, OperatorMode.MINUS];
    var isSameMode = true;
    var newAction, newOperator;

    do {
      newAction = actions[new Random().nextInt(actions.length)];
      newOperator = operators[new Random().nextInt(operators.length)];

      if (newAction != _actionMode || newOperator != _operatorMode) {
        isSameMode = false;
        break;
      }
    } while (isSameMode);

    changeActionMode(newAction);
    changeOperatorMode(newOperator);

    setModeDescription();
  }

  void setModeDescription() {
    var actionDesc = describeEnum(_actionMode);
    var operatorDesc = describeEnum(_operatorMode);
    _currentMode = "$actionDesc - $operatorDesc";
  }

  void setScore(int additionalScore,
      [int multiplier = 1, bool forceMultiply = false]) {
    if (additionalScore == 0) return;

    if (additionalScore == 1 || forceMultiply)
      _score += additionalScore * multiplier;
    else
      _score += additionalScore;

    if (_score > _highScore) {
      _highScore = _score;
    }
  }

  Future<void> saveHighScore() async {
    if (_score != _highScore) return;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('highScore', _highScore);
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('highScore') ?? 0;
  }

  playSwipe(String audio) {
    player.fixedPlayer.stop();
    player.play(audios[audio]);
  }

  getTileFontSize(int val) {
    var size = val > fourDigitLimit ? 30.0 : 35.0;
    if (screenWidth < 400) {
      size -= 10.0;
    }
    return size;
  }

  getButtonFontSize() {
    return screenWidth < 400 ? 28.0 : 34.0;
  }

  getModeFontSize() {
    return screenWidth < 400 ? 16.0 : 21.0;
  }

  getScoreFontSize(var score) {
    var size = screenWidth < 400 ? 16.0 : 21.0;
    if (score > 99999) {
      size -= 2.0;
    }
    return size;
  }

  getReadySetFontSize() {
    return screenWidth < 400 ? 40.0 : 50.0;
  }
}
