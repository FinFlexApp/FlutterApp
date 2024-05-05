import 'package:flutter/material.dart';

class ColorStyles{
  static const Gradient myGradient = LinearGradient(
  colors: [
    Color(0xFF4CA7EA),
    Colors.white,
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  );

  static const Color mainBackgroundColor = Color.fromARGB(255, 14, 22, 33);

  static const Color mainTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color metaTextColor = Color.fromARGB(128, 255, 255, 255);
  static const Color userMessageColor = Color.fromARGB(255, 43, 68, 102);
  static const Color botMessageColor = Color.fromARGB(255, 50, 129, 237);
  static const Color messageGroupColor = Color.fromARGB(255, 0, 48, 131);
  static const Color appBarMainColor = Color.fromARGB(150, 76, 167, 234);

  static const Color leaderFirstCardColor = Color.fromARGB(255, 205, 163, 56);
  static const Color leaderSecondCardColor = Color.fromARGB(255, 206, 219, 220);
  static const Color leaderThirdCardColor = Color.fromARGB(255, 188, 95, 43);

  static const Color leaderFirstTextColor = Color.fromARGB(255, 64, 37, 13);
  static const Color leaderSecondTextColor = Color.fromARGB(255, 74, 89, 90);
  static const Color leaderThirdTextColor = Color.fromARGB(255, 66, 37, 21);

  static const Color leaderDividerColor = Color.fromARGB(128, 255, 255, 255);


  static const Color testPassedColor = Color.fromARGB(255, 148, 255, 128);
  static const Color testNotPassedColor = Color.fromARGB(255, 203, 220, 200);
  static const Color testScoreColor = Color.fromARGB(255, 69, 54, 0);

  static const Color progressBarColor = Color.fromARGB(255, 39, 41, 98);

  static const Color questionColor = Color.fromARGB(255, 94, 98, 190);
}