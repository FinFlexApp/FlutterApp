import 'dart:convert';
import 'dart:io';
import 'package:finflex/api/auth-api.dart';
import 'package:finflex/api/news-api.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/app-container.dart';
import 'package:finflex/education/dto/chapter-dto.dart';
import 'package:finflex/education/dto/chapter-test-dto.dart';
import 'package:finflex/education/dto/question-dto.dart';
import 'package:finflex/news/dto/news-dto.dart';
import 'package:finflex/education/dto/question-meta-dto.dart';
import 'package:finflex/education/pages/chapters-page.dart';
import 'package:finflex/splash-screen.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter HTTP Demo',
      theme: ThemeData(
        highlightColor: Colors.blue,
        textTheme: CustomTextThemes.MainTextTheme,
        primarySwatch: Colors.blue,
      ),
      home: const FinFlexApp()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QuestionDTO? _qDTO;
  String _responseText = '';
  int _count = 0;

  Future<void> fetchData() async {
    //var request = await TestsApiService.GetChapters(11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ');
    //var request = await TestsApiService.GetRandomSite();
    //var request = await AuthApiService.Login('12@1.ru', 'AbcabgGRGRbhdt4523tgrc12!!!!');
    //var request = await AuthApiService.Login('pashok@mail.ru', 'AbcabgGRGRbhdt4523tgrc12!!!!');
    //var request = await NewsApiService.GetChapters('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ');
    var request = await TestsApiService.getQuestion(2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ');
    //var request = await TestsApiService.getQuestionsList(1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ');
    //var request = await TestsApiService.GetChapterTests(1, 11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ');
    //var request = await AuthApiService.Register('pashok@mail.ru', 'Pavelchik', 'Pavel', 'Zhugan', 'AbcabgGRGRbhdt4523tgrc12!!!!');
    //_chapterDTO = ChapterDTO.fromJson(json.decode(request.body)[0]);
      setState(() {
        _responseText = request.body;
        _qDTO = QuestionDTO.fromJson(json.decode(request.body));
        _count++;
      });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Text(_responseText + _count.toString()),
          ],
        ),
      ),
    );
  }
}

