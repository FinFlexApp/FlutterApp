import 'package:finflex/styles/button-styles.dart';
import 'package:flutter/material.dart';

class Styles {
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const StyledButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ButtonStyles.mainButtonStyle,
        
        onPressed: onPressed,
        child: Text(
          text
        ),
      ),
    );
  }
}