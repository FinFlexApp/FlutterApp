import 'package:finflex/styles/snackbar-styles.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/material.dart';

class CustomThemes{
  static ThemeData mainTheme = ThemeData(
    textTheme: CustomTextThemes.MainTextTheme,
    highlightColor: Colors.blue,
    snackBarTheme: CustomSnackbarThemes.MainSnackbarTheme,
    canvasColor: Color.fromARGB(255, 34, 58, 88),
    primaryColor: Colors.blue
  );

  static ThemeData chaptersTheme = ThemeData(
    textTheme: CustomTextThemes.ChapterTextTheme
  );

  static ThemeData testsPageTheme = ThemeData(
    textTheme: CustomTextThemes.TestsTextTheme
  );

  static ThemeData testTheme = ThemeData(
    textTheme: CustomTextThemes.TestTextTheme
  );

  static ThemeData resultsTheme = ThemeData(
    textTheme: CustomTextThemes.ResultsTextTheme
  );

  static ThemeData newsTheme = ThemeData(
    textTheme: CustomTextThemes.NewsTextTheme
  );

  static ThemeData botTheme = ThemeData(
    textTheme: CustomTextThemes.MainTextTheme
  );

  static ThemeData leadersTheme = ThemeData(
    textTheme: CustomTextThemes.MainTextTheme
  );

  static ThemeData profileTheme = ThemeData(
    textTheme: CustomTextThemes.ProfileTextTheme
  );
}