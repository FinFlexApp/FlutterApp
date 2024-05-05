import 'dart:convert';

import 'package:finflex/api/auth-api.dart';
import 'package:finflex/app-container.dart';
import 'package:finflex/auth/pages/login-page.dart';
import 'package:finflex/auth/pages/welcome-page.dart';
import 'package:finflex/education/pages/chapters-page.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/profile-handles/profile-prefs-handlers.dart';
import 'package:finflex/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  createState() => _splashScreenState();
}

class _splashScreenState extends State<SplashScreen> {
  ProfileData cachedProfileData = ProfileData(token: null, userId: null);
  
  Future<bool> loadAppWithToken() async {
    //await ProfilePrefs.setPrefsProfileData(ProfileData(token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ', userId: 11));

    cachedProfileData = await ProfilePrefs.getPrefsProfileData();
    if(cachedProfileData.token == null || cachedProfileData.userId == null) return false;

    var request = await AuthApiService.CheckToken(cachedProfileData.userId!, cachedProfileData.token!);
    await Future.delayed(Duration(seconds: 1));
    return json.decode(request.body)['check'];
  }

  @override
  Widget build(BuildContext context) {
  return FutureBuilder(
    future: loadAppWithToken(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/finflex-logo.png', height: 100, width: 100),
                SizedBox(height: 50),
                const CircularProgressIndicator(),
              ],
            )
          ),
        );
      } else if (snapshot.hasError) {
        return Text('Ошибка ${snapshot.error}');
      } else {
        if (snapshot.data!) {
          AppProcessDataProvider.of(context)!.profileData = cachedProfileData;

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FinFlexApp()),
            );
          });
          return Container();
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Theme(
                data: CustomThemes.mainTheme,
                child: WelcomePage())),
            );
          });
          return Container();
        }
      }
    },
  );
}
}
