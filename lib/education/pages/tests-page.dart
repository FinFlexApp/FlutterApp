import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/test-dto.dart';
import 'package:finflex/education/pages/test-proccess-page.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChapterTestsPage extends StatefulWidget {
  final int chapterId;
  final String chapterDescription;

  const ChapterTestsPage({super.key, required this.chapterId, required this.chapterDescription});

  @override
  _ChapterTestsPageState createState() => _ChapterTestsPageState();
}

class _ChapterTestsPageState extends State<ChapterTestsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<TestDTO>> loadTests(
      int chapterId, int userId, String token) async {
    var request = await TestsApiService.GetChapterTests(
        chapterId, userId, token);
    List<dynamic> rawTestList = json.decode(request.body);
    List<TestDTO> testList = [];
    for (int i = 0; i < rawTestList.length; i++) {
      testList.add(TestDTO.fromJson(rawTestList[i]));
    }

    return testList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Тесты")),
        body: Column(
          children: [
            Text(widget.chapterDescription, style: TextStyle(color: Colors.black),),
            Expanded(
              child: FutureBuilder(
                  future: loadTests(
                      widget.chapterId,
                      11,
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Ошибка ${snapshot.error}');
                    } else {
                      return FadeTransition(
                        opacity: _animation,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return TestCard(
                                  testData: snapshot.data![index], testIndex: index);
                            }),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final TestDTO testData;
  final int testIndex;
  const TestCard(
      {super.key, required this.testData, required this.testIndex});

  void onTestClick(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: 
        (context)=>TestPage(testId: testData.testId)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Theme(
      data: Theme.of(context).copyWith(textTheme: CustomTextThemes.TestTextTheme),
      child: GestureDetector(
          onTap:() {onTestClick(context);},
          child: Card(
              color: Colors.blue,
              shape: ContinuousRectangleBorder(
                side: BorderSide(width: 8),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Тест ${testIndex + 1}', style: Theme.of(context).textTheme.labelLarge),
                              Text(' · '),
                              Text(
                                '${testData.questionsCount} вопросов', style: Theme.of(context).textTheme.labelSmall
                              )
                          ]),
                          Text(testData.title, style: Theme.of(context).textTheme.titleLarge)
                        ],),
                    ),
                    Container(
                      decoration: const ShapeDecoration(
                        color: ColorStyles.testPassedColor,
                        shape: ContinuousRectangleBorder(
                          side: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        )
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const ShapeDecoration(
                              color: ColorStyles.testPassedColor,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              )
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text(testData.isPassed ? 'Пройден' : 'Не пройден', style: Theme.of(context).textTheme.labelMedium),
                                testData.isPassed ? Image.asset('assets/icons/success-icon.png') : Container()
                              ],),
                          ),
                          Row(
                            children: [
                              Text('${testData.userScore}/${testData.maxScore}'),
                              Image.asset('assets/icons/crown-icon.png')
                            ],
                          )
                      ],),
                    )
                  ],),
              )
          )
        ),
      );
  }
}
