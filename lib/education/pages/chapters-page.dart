import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/chapter-dto.dart';
import 'package:finflex/education/pages/tests-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key});

  Future<List<ChapterDTO>> loadChapters(int userId, String token) async {
    var request = await TestsApiService.GetChapters(userId, token);
    List<dynamic> rawChapterList = json.decode(request.body);
    List<ChapterDTO> chapterList = [];
    for (int i = 0; i < rawChapterList.length; i++) {
      chapterList.add(ChapterDTO.fromJson(rawChapterList[i]));
    }

    return chapterList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadChapters(11,
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Ошибка ${snapshot.error}');
          } else {
                return ListView.builder(

                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ChapterCard(
                          chapterData: snapshot.data![index], chapterIndex: index),
                      SizedBox(height: 15)
                    ],
                  );
                });
          }
        });
  }
}

class ChapterCard extends StatelessWidget {
  final ChapterDTO chapterData;
  final int chapterIndex;
  const ChapterCard(
      {super.key, required this.chapterData, required this.chapterIndex});

  void onChapterClick(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: 
        (context)=>ChapterTestsPage(chapterId: chapterData.chapterId, chapterDescription: chapterData.description)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Colors.black,
      transitionDuration: Duration(milliseconds: 500),
      openShape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
      closedShape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, action)=> ChapterTestsPage(chapterId: chapterData.chapterId, chapterDescription: chapterData.description),
      closedBuilder: (context, openContainer) => GestureDetector(
        onTap: openContainer,
        child: Card(
            color: Colors.blue,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Глава${chapterIndex}'),
                    Text(chapterData.title, style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      children: [
                        Container(
                            child: Row(
                          children: [
                            Text(
                                '${chapterData.passedTests}/${chapterData.testsCount}'),
                            SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.asset("assets/icons/test-icon.png", fit: BoxFit.contain))
                          ],
                        )),
                        Container(
                            child: Row(
                          children: [
                            Text(chapterData.chapterScore.toString()),
                            SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.asset("assets/icons/crown-icon.png", fit: BoxFit.contain))
                          ],
                        )
                        ),
                      ],
                    ),
                    Text(chapterData.description)
                  ],
                ))),
      ),
    );
  }
}
