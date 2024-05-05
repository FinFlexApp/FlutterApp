import 'package:finflex/styles/colors.dart';
import 'package:flutter/material.dart';

class ButtonStyles{
  static final ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(255, 67, 148, 202),
  foregroundColor: const Color.fromARGB(255, 255, 254, 254),
  shape: ContinuousRectangleBorder(
    borderRadius: BorderRadius.circular(40)
  ),
  textStyle: TextStyle(
    fontFamily: 'Inter',
      fontSize: 20,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold
  ));
  //static final ButtonStyle 

  static final ButtonStyle visibilityButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 145, 184, 236),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(0),
      bottomLeft: Radius.circular(0),
      topRight: Radius.circular(15),
      bottomRight: Radius.circular(15),
      )
    )
  );
}

