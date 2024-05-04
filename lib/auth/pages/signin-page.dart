import 'dart:convert';

import 'package:finflex/api/auth-api.dart';
import 'package:finflex/app-container.dart';
import 'package:finflex/auth/dto/login-response-dto.dart';
import 'package:finflex/auth/dto/register-response-dto.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/profile-handles/profile-prefs-handlers.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool registerProcessing = false;
  bool hiddenPassword = true;


  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<RegisterResponseDTO> sendRegisterData(String email, String nickname, String firstName, String surName, String password) async{

    var request = await AuthApiService.Register(email, nickname, firstName, surName, password);
    var registerResponse = RegisterResponseDTO.fromJson(json.decode(request.body));

    return registerResponse;
  }

  void registerAndLoginHandler(BuildContext context, String email, String nickname, String firstName, String surName, String password) async{
    setState(() {
      registerProcessing = true;
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
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: surnameController,
              decoration: CustomDecorations.MainInputDecoration('Фамилия')
            ),
            TextFormField(
              controller: nameController,
              decoration: CustomDecorations.MainInputDecoration('Имя')
            ),
            TextFormField(
              controller: nicknameController,
              decoration: CustomDecorations.MainInputDecoration('Никнейм')
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: passwordController,
                    decoration: CustomDecorations.MainInputDecoration('Пароль'),
                    obscureText: hiddenPassword,
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                  setState(() {
                    hiddenPassword = !hiddenPassword;
                  });
                  },
                  child: hiddenPassword ? Image.asset('assets/icons/bot-nav-icon.png') : Image.asset('assets/icons/crown-icon.png')
                  )
              ],
            ),
            TextFormField(
              controller: confirmPasswordController,
              decoration: CustomDecorations.MainInputDecoration('Повтор пароля'),
              obscureText: true,
            ),
            TextFormField(
              controller: emailController,
              decoration: CustomDecorations.MainInputDecoration('E-Mail адрес'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: (){registerAndLoginHandler(context, emailController.text, nicknameController.text, nameController.text, surnameController.text, passwordController.text);},
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Зарегистрироваться'),
              ),
              style: ButtonStyles.mainButtonStyle,
            )
          ],
        ),
      ),
    );
  }
}