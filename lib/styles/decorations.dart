import 'package:flutter/material.dart';

class CustomDecorations{
  static InputDecoration MainInputDecoration(String hintText, bool validated) => InputDecoration(
    error: !validated ? Container() : null,
    errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 245, 81, 55),
      width: 3,
    ),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 122, 151, 238),
      width: 3,
    ),
  ),
    filled: true,
    hintStyle: TextStyle(color: Color.fromARGB(128, 255, 255, 255)),
      fillColor: Color.fromARGB(255, 49, 73, 142),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 1
        )));
  
  static const ContinuousRectangleBorder InnerEducationCardShape = ContinuousRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(30))
  );
  static const ContinuousRectangleBorder OuterEducationCardShape = ContinuousRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(40))
  );
  
  static const Decoration progressDataDecoration = ShapeDecoration(
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    color: Colors.white,
  );

  static const Decoration modalShapeDecoration = ShapeDecoration(
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
    color: Color.fromARGB(255, 48, 115, 170),
  );
}