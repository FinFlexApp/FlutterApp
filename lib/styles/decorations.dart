import 'package:flutter/material.dart';

class CustomDecorations{
  static InputDecoration MainInputDecoration(String hintText) => InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))));
  
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
}