import 'package:finflex/auth/pages/login-page.dart';
import 'package:finflex/auth/pages/signin-page.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Добро пожаловать!"),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Войти"),
                style: ButtonStyles.mainButtonStyle,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Text("Зарегистрироваться"),
                style: ButtonStyles.mainButtonStyle,
              ),
            ],
          ),
        ),
      );
  }

}