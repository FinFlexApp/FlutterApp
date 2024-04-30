import 'dart:convert';
import 'dart:html';
import 'package:finflex/api/auth-api.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/chapter-dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChapterDTO? _chapterDTO;
  String _responseText = '';
  int _count = 0;

  Future<void> fetchData() async {
    //var request = await TestsApiService.GetChapters(11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ');
    //var request = await TestsApiService.GetRandomSite();
    //var request = await AuthApiService.Login('12@1.ru', 'AbcabgGRGRbhdt4523tgrc12!!!!');
    var request = await AuthApiService.Login('pashok@mail.ru', 'AbcabgGRGRbhdt4523tgrc12!!!!');
    //var request = await AuthApiService.Register('pashok@mail.ru', 'Pavelchik', 'Pavel', 'Zhugan', 'AbcabgGRGRbhdt4523tgrc12!!!!');
    //_chapterDTO = ChapterDTO.fromJson(json.decode(request.body)[0]);
      setState(() {
        _responseText = request.body;
        
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