import 'dart:convert';

import 'package:finflex/api/auth-api.dart';
import 'package:finflex/auth/pages/login-page.dart';
import 'package:finflex/education/pages/chapters-page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  createState() => _splashScreenState();
}

class _splashScreenState extends State<SplashScreen> {
  Future<bool> checkToken(int userId, String token) async {
    var request = await AuthApiService.CheckToken(userId, token);

    return json.decode(request.body)['check'];
  }

  @override
  Widget build(BuildContext context) {
  return FutureBuilder(
    future: checkToken(11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Ошибка ${snapshot.error}');
      } else {
        if (snapshot.data!) {
          // Defer navigation after the build is complete
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChaptersPage()),
            );
          });
          return Text("Успешно!");
        } else {
          // Defer navigation after the build is complete
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          });
          return Text("Необходимо войти!");
        }
      }
    },
  );
}
}
