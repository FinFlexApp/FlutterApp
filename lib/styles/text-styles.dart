import 'package:finflex/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomTextThemes{
  static const MainTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 32,
      color: ColorStyles.mainTextColor,
      fontWeight: FontWeight.bold
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 24,
      color: ColorStyles.mainTextColor,
      fontWeight: FontWeight.bold
    ),
    titleMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: ColorStyles.mainTextColor,
      fontWeight: FontWeight.bold
    ),
    displaySmall: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.bold
    ),
    displayMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.w600
    ),
    displayLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 24,
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.w800
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      color: ColorStyles.mainTextColor,
      fontWeight: FontWeight.w600
    ),
    bodySmall: TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      color: ColorStyles.metaTextColor,
      fontWeight: FontWeight.w600
    ),
    labelLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: Color.fromARGB(255, 255, 249, 249),
      fontWeight: FontWeight.w500
    ),
  );

  static const TestTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 32,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),
    titleLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),
    labelLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w900
    ),
    labelMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),
    labelSmall: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),

  );

  static const ChapterTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 42,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),
    titleMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.normal
    ),
    labelLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w900
    ),
    labelMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
    ),
    displayMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold
    ),

  );
}