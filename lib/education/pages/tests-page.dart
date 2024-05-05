import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/test-dto.dart';
import 'package:finflex/education/pages/test-proccess-page.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/styles/card-colors.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:finflex/styles/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class ChapterTestsPage extends StatefulWidget {
  final int chapterId;
  final String chapterDescription;
  final Function refreshCallBack;
  final Color barColor;

  const ChapterTestsPage({super.key, required this.chapterId, required this.chapterDescription, required this.refreshCallBack, required this.barColor});

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

  Future<List<TestDTO>> loadTests(int chapterId, ProfileData profileData) async {
      var userId = profileData.userId!;
      var token = profileData.token!;

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
        backgroundColor: ColorStyles.mainBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: widget.barColor,
          title: Text("Тесты выбранной главы"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.refreshCallBack();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.chapterDescription, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 20),
              Text("Тесты", style: Theme.of(context).textTheme.headlineLarge),
              Expanded(
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  interactive: true,
                  radius: Radius.circular(20),
                  child: Expanded(
                    child: FutureBuilder(
                        future: loadTests(
                            widget.chapterId, AppProcessDataProvider.of(context)!.profileData),
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
                                    return Column(
                                      children: [
                                        TestCard(
                                            testData: snapshot.data![index], testIndex: index, refreshCallBack: (){widget.refreshCallBack(); setState(() {});}),
                                        SizedBox(height: 10)
                                      ],
                                    );
                                  }),
                            );
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final TestDTO testData;
  final int testIndex;
  final Function refreshCallBack;
  late TestColor colorSet;

  TestCard({super.key, required this.testData, required this.testIndex, required this.refreshCallBack}){
    colorSet = TestCardColors.GetColorByIndex(testIndex);
  }

  void onTestClick(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: 
        (context)=> Theme(data: CustomThemes.testTheme, child: TestPage(testId: testData.testId, refreshCallBack: refreshCallBack))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!testData.isUnlocked){
      return Card(
        color: colorSet.borderColor,
        shape: CustomDecorations.OuterEducationCardShape,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CachedNetworkImage(
                imageUrl: testData.imageSource,
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageBuilder: (context, imageProvider){
                  return Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight)
                    )
                  );
                }),
              Container(
                decoration: ShapeDecoration(
                  shape: CustomDecorations.InnerEducationCardShape,
                  color: colorSet.blockedColor
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/lock-icon.svg', fit: BoxFit.fitHeight),
                    SizedBox(width: 20),
                    Expanded(child: Text('Тест "${testData.title}" заблокирован', style: Theme.of(context).textTheme.bodyMedium,)),
                  ],
                ),
              ),
            ],
          ),
        )
      );
    }
    return Theme(
      data: Theme.of(context).copyWith(textTheme: CustomTextThemes.TestsTextTheme),
      child: GestureDetector(
          onTap:() {onTestClick(context);},
          child: Card(
              color: colorSet.backgroundColor,
              shape: ContinuousRectangleBorder(
                side: BorderSide(width: 8),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Тест ${testIndex + 1}', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: colorSet.metaColor)),
                                Text(' · ', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: colorSet.metaColor)),
                                Text(
                                  '${testData.questionsCount} вопросов', style: Theme.of(context).textTheme.labelSmall!.copyWith(color: colorSet.metaColor)
                                )
                            ]),
                            Text(testData.title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: colorSet.titleColor))
                          ],),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: const ShapeDecoration(
                        shape: ContinuousRectangleBorder(
                          side: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        )
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              color: testData.isPassed ? ColorStyles.testPassedColor : ColorStyles.testNotPassedColor,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              )
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text(testData.isPassed ? 'Пройден' : 'Не пройден', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: const Color.fromARGB(120, 0, 0, 0))),
                                testData.isPassed ? Icon(Icons.check) : Container()
                              ],),
                          ),
                          Row(
                            children: [
                              Text('${testData.userScore}/${testData.maxScore}', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: ColorStyles.testScoreColor)),
                              SvgPicture.asset('assets/icons/crown-icon.svg', width: 30)
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
