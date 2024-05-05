import 'package:finflex/auth/pages/login-page.dart';
import 'package:finflex/auth/pages/signin-page.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: ColorStyles.mainBackgroundColor,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            child: Image.asset('assets/icons/finflex-logo.png')),
            SizedBox(height: 20),
          Center(child: Text("Добро пожаловать!", style: Theme.of(context).textTheme.headlineLarge)),
          SizedBox(height: 10),
          Center(child: Text("Как мы можем к вам обращаться?", style: Theme.of(context).textTheme.labelLarge)),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Войти"),
            ),
            style: ButtonStyles.mainButtonStyle,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Зарегистрироваться")),
            style: ButtonStyles.mainButtonStyle,
          ),
        ],
      ),
    );
  }

}