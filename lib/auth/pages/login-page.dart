import 'dart:convert';

import 'package:finflex/api/auth-api.dart';
import 'package:finflex/app-container.dart';
import 'package:finflex/auth/dto/login-response-dto.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/profile-handles/profile-prefs-handlers.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/decorations.dart';
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

  bool isValidated = true;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<LoginResponseDTO> sendLoginData(String email, String password) async{

    var request = await AuthApiService.Login(email, password);
    var loginResponse = LoginResponseDTO.fromJson(json.decode(request.body));

    return loginResponse;
  }

  void loginHandler(BuildContext context, String email, String password) async{
    setState(() {
      loginProcessing = true;
    });

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
        isValidated = false;
      });
    }

    setState(() {
      loginProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: CustomDecorations.MainInputDecoration('E-Mail адрес'),
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: passwordController,
                    decoration: CustomDecorations.MainInputDecoration('Пароль'),
                    obscureText: shownPassword,
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                  setState(() {
                    shownPassword = !shownPassword;
                  });
                  },
                  child: shownPassword ? Image.asset('assets/icons/bot-nav-icon.png') : Image.asset('assets/icons/crown-icon.png')
                  )
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              color: Colors.black,
              child: !isValidated ? Text("Что-то пошло не так") : Text("Все норм"),
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
    );
  }
}