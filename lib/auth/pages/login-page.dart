import 'dart:convert';

import 'package:finflex/api/auth-api.dart';
import 'package:finflex/app-container.dart';
import 'package:finflex/auth/dto/login-response-dto.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/profile-handles/profile-prefs-handlers.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  bool loginProcessing = false;
  bool shownPassword = false;

  String validationMessage = '';

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool passwordValidated = true;
  bool emailValidated = true;

  Future<LoginResponseDTO> sendLoginData(String email, String password) async{

    var request = await AuthApiService.Login(email, password);
    var loginResponse = LoginResponseDTO.fromJson(json.decode(request.body));

    return loginResponse;
  }

  String validateData(String email, String password){
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        emailValidated = false;
      });
      return "Ошибка валидации : введен некорректный E-Mail адрес";
    } else {
      setState(() {
        emailValidated = true;
      });
    }
    if (password.isEmpty) {
      setState(() {
        emailValidated = false;
      });
      return "Ошибка валидации : не введен пароль";
    } else {
      setState(() {
        emailValidated = true;
      });
    }

    if (password.length < 8) {
      setState(() {
        emailValidated = false;
      });
      return "Ошибка валидации : введенный пароль содержит менее 8 символов";
    } else {
      setState(() {
        emailValidated = true;
      });
    }

    return '';
  }

  void loginHandler(BuildContext context, String email, String password) async{
    setState(() {
      loginProcessing = true;
    });

    validationMessage = validateData(email, password);
    if(validationMessage.isNotEmpty) return;

    var loginResponse = await sendLoginData(email, password);

    if(loginResponse.loginData != null){
      ProfileData profileData = ProfileData(token: loginResponse.loginData!.token, userId: loginResponse.loginData!.userId);
      //profileData = ProfileData(token: null, userId: null);

      ProfilePrefs.setPrefsProfileData(profileData);
      AppProcessDataProvider.of(context)!.profileData = profileData;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FinFlexApp()),
      );
    }
    else{
      setState(() {
        validationMessage = "Ошибка сервера : пользователя со введёнными данными не существует";
      });
    }

    setState(() {
      loginProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorStyles.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.appBarMainColor,
        title: Text('Вход'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text("Вход в аккаунт", style: Theme.of(context).textTheme.headlineLarge,)),
              SizedBox(height: 30),
              TextFormField(
                style: CustomTextThemes.InputTextStyle,
                controller: emailController,
                decoration: CustomDecorations.MainInputDecoration('E-Mail адрес', emailValidated),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: CustomTextThemes.InputTextStyle,
                      controller: passwordController,
                      decoration: CustomDecorations.MainInputDecoration('Пароль', passwordValidated),
                      obscureText: shownPassword,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                    setState(() {
                      shownPassword = !shownPassword;
                    });
                    },
                    style: ButtonStyles.visibilityButtonStyle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: shownPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    )
                    )
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: validationMessage.isNotEmpty ? Container(
                padding: EdgeInsets.all(10),
                decoration: CustomDecorations.progressDataDecoration,
                child: Text(validationMessage, style: TextStyle(color: Colors.red),),
              ) : Container(),
              ),
              ElevatedButton(
                style: ButtonStyles.mainButtonStyle,
                onPressed: (){loginHandler(context, emailController.text, passwordController.text);},
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Войти'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}