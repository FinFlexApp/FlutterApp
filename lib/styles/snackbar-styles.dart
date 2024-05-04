import 'package:flutter/material.dart';

class CustomSnackbarThemes{
  static const SnackBarThemeData MainSnackbarTheme = SnackBarThemeData(
    backgroundColor: Colors.black,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      side: BorderSide(width: 2, color: Colors.white)
    ),
    behavior: SnackBarBehavior.fixed
  );
}