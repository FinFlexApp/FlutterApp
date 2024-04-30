import 'package:finflex/styles/colors.dart';
import 'package:flutter/material.dart';

class ButtonStyles{
  static final ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
  foregroundColor: const Color.fromARGB(255, 255, 254, 254),
  shape: ContinuousRectangleBorder(
    borderRadius: BorderRadius.circular(100)
  ),
  textStyle: const TextStyle(fontSize: 100, color: Colors.black),
  padding: const EdgeInsets.all(20),
  );
}

