import 'dart:ui';

import 'package:flutter/material.dart';

class ChapterCardColors{
  static final Map<String, ChapterColor> ColorsMap = {
    'black': ChapterColor(
      titleColor: const Color.fromARGB(255, 0, 0, 0),
      metaColor: const Color.fromARGB(128, 0, 0, 0),
      borderColor: const Color.fromARGB(255, 0, 0, 0),
      blockedColor: const Color.fromARGB(199, 40, 40, 40),
      backgroundColor: const Color.fromARGB(255, 29, 26, 26)
    ),
    'blue': ChapterColor(
      titleColor: const Color.fromARGB(255, 3, 0, 167),
      metaColor: const Color.fromARGB(128, 3, 0, 167),
      borderColor: const Color.fromARGB(255, 3, 0, 167),
      blockedColor: const Color.fromARGB(199, 1, 0, 70),
      backgroundColor: const Color.fromARGB(255, 34, 23, 100)
    ),
    'red': ChapterColor(
      titleColor: const Color.fromARGB(255, 167, 0, 0),
      metaColor: const Color.fromARGB(128, 167, 0, 0),
      borderColor: const Color.fromARGB(255, 167, 0, 0),
      blockedColor: const Color.fromARGB(199, 70, 0, 0),
      backgroundColor: const Color.fromARGB(255, 100, 30, 30)
    ),
    'green': ChapterColor(
      titleColor: const Color.fromARGB(255, 3, 167, 0),
      metaColor: const Color.fromARGB(128, 3, 167, 0),
      borderColor: const Color.fromARGB(255, 3, 167, 0),
      blockedColor: const Color.fromARGB(200, 1, 40, 0),
      backgroundColor: const Color.fromARGB(255, 30, 100, 30)),
  };

  static ChapterColor GetColorByIndex(int index){
    return ColorsMap.values.elementAt(index % ColorsMap.length);
  }
}

class ChapterColor{
  final Color titleColor;
  final Color metaColor;
  final Color borderColor;
  final Color blockedColor;
  final Color backgroundColor;

  ChapterColor({required this.blockedColor, required this.titleColor, required this.metaColor, required this.borderColor, required this.backgroundColor});
}



class TestCardColors{
  static final Map<String, TestColor> ColorsMap = {
    'black': TestColor(
      titleColor: const Color.fromARGB(255, 0, 0, 0),
      metaColor: const Color.fromARGB(128, 0, 0, 0),
      borderColor: const Color.fromARGB(255, 0, 0, 0),
      blockedColor: const Color.fromARGB(199, 40, 40, 40),
      backgroundColor: const Color.fromARGB(255, 29, 26, 26)
    ),
    'blue': TestColor(
      titleColor: const Color.fromARGB(255, 3, 0, 167),
      metaColor: const Color.fromARGB(128, 3, 0, 167),
      borderColor: const Color.fromARGB(255, 3, 0, 167),
      blockedColor: const Color.fromARGB(199, 1, 0, 70),
      backgroundColor: const Color.fromARGB(255, 34, 23, 100)
    ),
    'red': TestColor(
      titleColor: const Color.fromARGB(255, 167, 0, 0),
      metaColor: const Color.fromARGB(128, 167, 0, 0),
      borderColor: const Color.fromARGB(255, 167, 0, 0),
      blockedColor: const Color.fromARGB(199, 70, 0, 0),
      backgroundColor: const Color.fromARGB(255, 100, 30, 30)
    ),
    'green': TestColor(
      titleColor: const Color.fromARGB(255, 3, 167, 0),
      metaColor: const Color.fromARGB(128, 3, 167, 0),
      borderColor: const Color.fromARGB(255, 3, 167, 0),
      blockedColor: const Color.fromARGB(200, 1, 40, 0),
      backgroundColor: const Color.fromARGB(255, 30, 100, 30)),
  };

  static TestColor GetColorByIndex(int index){
    return ColorsMap.values.elementAt(index % ColorsMap.length);
  }
}

class TestColor{
  final Color titleColor;
  final Color metaColor;
  final Color borderColor;
  final Color blockedColor;
  final Color backgroundColor;

  TestColor({required this.blockedColor, required this.titleColor, required this.metaColor, required this.borderColor, required this.backgroundColor});
}