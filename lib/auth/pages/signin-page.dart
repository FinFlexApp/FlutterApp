import 'dart:convert';

import 'package:finflex/api/auth-api.dart';
import 'package:finflex/app-container.dart';
import 'package:finflex/auth/dto/login-response-dto.dart';
import 'package:finflex/auth/dto/register-response-dto.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/profile-handles/profile-prefs-handlers.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool registerProcessing = false;
  bool hiddenPassword = true;
  String validationMessage = "";


  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool surnameValidated = true;
  bool nameValidated = true;
  bool nicknameValidated = true;
  bool passwordValidated = true;
  bool confirmPasswordValidated = true;
  bool emailValidated = true;

  Future<RegisterResponseDTO> sendRegisterData(String email, String nickname, String firstName, String surName, String password) async{

    var request = await AuthApiService.Register(email, nickname, firstName, surName, password);
    var registerResponse = RegisterResponseDTO.fromJson(json.decode(request.body));

    return registerResponse;
  }

  String validateData(String email, String nickname, String firstName, String surName, String password, String repeatedPassword) {
  String errorMessage = "";

  if (email.isEmpty) {
    setState(() {
      emailValidated = false;
    });
    errorMessage = "Ошибка валидации : не введена почта";
  } else {
    setState(() {
      emailValidated = true;
    });
  }

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(email)) {
    setState(() {
      emailValidated = false;
    });
    errorMessage = "Ошибка валидации : введен некорректный E-Mail адрес";
  } else {
    setState(() {
      emailValidated = true;
    });
  }

  if (surName.isEmpty) {
    setState(() {
      surnameValidated = false;
    });
    errorMessage = "Ошибка валидации : не введена фамилия";
  } else {
    setState(() {
      surnameValidated = true;
    });
  }

  if (firstName.isEmpty) {
    setState(() {
      nameValidated = false;
    });
    errorMessage = "Ошибка валидации : не введено имя";
  } else {
    setState(() {
      nameValidated = true;
    });
  }

  if (nickname.isEmpty) {
    setState(() {
      nicknameValidated = false;
    });
    errorMessage = "Ошибка валидации : не введен никнейм";
  } else {
    setState(() {
      nicknameValidated = true;
    });
  }

  if (password.isEmpty) {
    setState(() {
      passwordValidated = false;
    });
    errorMessage = "Ошибка валидации : не введён пароль";
  } else {
    setState(() {
      passwordValidated = true;
    });
  }

  if (password.length < 8) {
    setState(() {
      passwordValidated = false;
    });
    errorMessage = "Ошибка валидации : пароль содержит менее 8 символов";
  } else {
    setState(() {
      passwordValidated = true;
    });
  }

  if (password != repeatedPassword) {
    setState(() {
      confirmPasswordValidated = false;
    });
    errorMessage = "Ошибка валидации : пароли не совпадают";
  } else {
    setState(() {
      confirmPasswordValidated = true;
    });
  }

  return errorMessage;
}

  void registerAndLoginHandler(BuildContext context, String email, String nickname, String firstName, String surName, String password, String repeatedPassword) async{
    setState(() {
      registerProcessing = true;
      validationMessage = validateData(email, nickname, firstName, surName, password, repeatedPassword);
      if(validationMessage.isNotEmpty) return;
    });

    var registerResponse = await sendRegisterData(email, nickname, firstName, surName, password);

    if(registerResponse.registerData != null){
      var request = await AuthApiService.Login(email, password);
      var loginResponse = LoginResponseDTO.fromJson(json.decode(request.body));

      ProfileData profileData = ProfileData(token: loginResponse.loginData!.token, userId: loginResponse.loginData!.userId);
      //profileData = ProfileData(token: null, userId: null);

      ProfilePrefs.setPrefsProfileData(profileData);
      AppProcessDataProvider.of(context)!.profileData = profileData;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FinFlexApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.appBarMainColor,
        title: Text('Регистрация'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: Text("Регистрация", style: Theme.of(context).textTheme.headlineLarge,)),
              SizedBox(height: 30),
              TextFormField(
                style: CustomTextThemes.InputTextStyle,
                controller: emailController,
                decoration: CustomDecorations.MainInputDecoration('E-Mail адрес', emailValidated),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: CustomTextThemes.InputTextStyle,
                controller: surnameController,
                decoration: CustomDecorations.MainInputDecoration('Фамилия', surnameValidated)
              ),
              SizedBox(height: 20),
              TextFormField(
                style: CustomTextThemes.InputTextStyle,
                controller: nameController,
                decoration: CustomDecorations.MainInputDecoration('Имя', nameValidated)
              ),
              SizedBox(height: 20),
              TextFormField(
                style: CustomTextThemes.InputTextStyle,
                controller: nicknameController,
                decoration: CustomDecorations.MainInputDecoration('Никнейм', nicknameValidated)
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: CustomTextThemes.InputTextStyle,
                      controller: passwordController,
                      decoration: CustomDecorations.MainInputDecoration('Пароль', passwordValidated),
                      obscureText: hiddenPassword,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                    setState(() {
                      hiddenPassword = !hiddenPassword;
                    });
                    },
                    style: ButtonStyles.visibilityButtonStyle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: hiddenPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    )
                    )
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                style: CustomTextThemes.InputTextStyle,
                controller: confirmPasswordController,
                decoration: CustomDecorations.MainInputDecoration('Повтор пароля', confirmPasswordValidated),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: validationMessage.isNotEmpty ? Container(
                padding: EdgeInsets.all(10),
                decoration: CustomDecorations.progressDataDecoration,
                child: Text(validationMessage, style: TextStyle(color: Colors.red)),
              ) : Container()),
              ElevatedButton(
                onPressed: (){registerAndLoginHandler(context, emailController.text, nicknameController.text, nameController.text, surnameController.text, passwordController.text, confirmPasswordController.text);},
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Зарегистрироваться'),
                ),
                style: ButtonStyles.mainButtonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}