import 'package:flutter/material.dart';

const String aboutUs =
    "       We are two siblings that are highly enthusiastic about building apps that aim to provide enjoyment, information, or both. One is equipped with astounding coding skills that make each app easy to do, while the other has cuteness that baffles everyone. With our combined efforts, an astonishing app will be born!";
const Color lightBrown = Color.fromARGB(255, 205, 193, 180);
const Color darkBrown = Color.fromARGB(255, 187, 173, 160);
const Color tan = Color.fromARGB(255, 238, 228, 218);
const Color greyText = Color.fromARGB(255, 119, 110, 101);

const Color progressBarBg = Colors.orange;
const Color progressBarCap = Colors.white;

const Color buttonBg = Color.fromARGB(255, 246, 124, 95);
const Color buttonText = Colors.white;
ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    primary: buttonBg,
    shape:
        new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)));

const TextStyle mainMenuTextStyle = TextStyle(
  fontWeight: FontWeight.w900,
  fontSize: 30.0,
  color: Colors.yellowAccent,
  fontFamily: 'PatrickHand',
);

const TextStyle textStyleSize34FontWeight800 = TextStyle(
  color: buttonText,
  fontSize: 34,
  fontWeight: FontWeight.w800,
);

const TextStyle textStyleSize21FontWeight900 = TextStyle(
  color: greyText,
  fontSize: 21,
  fontWeight: FontWeight.w900,
);

const TextStyle textStyleSize10FontWeight800 = TextStyle(
  color: buttonText,
  fontSize: 10,
  fontWeight: FontWeight.w800,
);

const int fourDigitLimit = 999;
const int boardSize = 4;
const int maxTimerInSeconds = 30;
const int maxChangeModeTimerInSeconds = 7;
const readySetStrings = ["READY", "SET", "GO!!!", ""];

const Map<int, Color> numTileColor = {
  2: tan,
  4: tan,
  8: Color.fromARGB(255, 242, 177, 121),
  16: Color.fromARGB(255, 245, 149, 99),
  32: Color.fromARGB(255, 246, 124, 95),
  64: const Color.fromARGB(255, 246, 95, 64),
  128: const Color.fromARGB(255, 235, 208, 117),
  256: const Color.fromARGB(255, 237, 203, 103),
  512: const Color.fromARGB(255, 236, 201, 85),
  1024: const Color.fromARGB(255, 229, 194, 90),
  2048: const Color.fromARGB(255, 232, 192, 70),
};
