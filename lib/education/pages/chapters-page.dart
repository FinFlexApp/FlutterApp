import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/chapter-dto.dart';
import 'package:finflex/education/pages/tests-page.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/styles/card-colors.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:finflex/styles/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChaptersPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _chaptersPageState();

}

class _chaptersPageState extends State<ChaptersPage> {

  Future<List<ChapterDTO>> loadChapters(ProfileData profileData) async {
    var userId = profileData.userId!;
    var token = profileData.token!;


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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text("Главы", style: Theme.of(context).textTheme.headlineLarge),
        ),
        Expanded(
          child: Scrollbar(
            thickness: 5,
            thumbVisibility: true,
            interactive: true,
            radius: Radius.circular(20),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder(
                      future: loadChapters(AppProcessDataProvider.of(context)!.profileData),
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
                                        chapterData: snapshot.data![index], chapterIndex: index, refreshCallBack: (){ setState(() {});}),
                                    SizedBox(height: 15)
                                  ],
                                );
                              });
                        }
                      }),
                ),
                SizedBox(width: 20)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChapterCard extends StatelessWidget {
  final ChapterDTO chapterData;
  final int chapterIndex;
  final Function refreshCallBack;
  late ChapterColor colorSet;

  ChapterCard({super.key, required this.chapterData, required this.chapterIndex, required this.refreshCallBack}){
    colorSet = ChapterCardColors.GetColorByIndex(chapterIndex);
  }

  void onChapterClick(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: 
        (context)=>ChapterTestsPage(chapterId: chapterData.chapterId, chapterDescription: chapterData.description, refreshCallBack: refreshCallBack, barColor: colorSet.backgroundColor)
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if(!chapterData.isUnlocked){
      return Card(
        color: colorSet.borderColor,
        shape: CustomDecorations.OuterEducationCardShape,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CachedNetworkImage(
                imageUrl: chapterData.imageSource,
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
                    Expanded(child: Text('Глава "${chapterData.title}" заблокирована')),
                  ],
                ),
              ),
            ],
          ),
        )
      );
    }
    
    return OpenContainer(
      closedColor: colorSet.borderColor,
      openColor: colorSet.borderColor,
      transitionDuration: Duration(milliseconds: 500),
      openShape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
      closedShape: CustomDecorations.OuterEducationCardShape,
      transitionType: ContainerTransitionType.fade,
      openBuilder: (contexto, action)=> Theme(data: CustomThemes.testsPageTheme, child: ChapterTestsPage(chapterId: chapterData.chapterId, chapterDescription: chapterData.description, refreshCallBack: refreshCallBack, barColor: colorSet.backgroundColor)),
      closedBuilder: (context, openContainer) => GestureDetector(
        onTap: openContainer,
        child: Card(
            color: colorSet.backgroundColor,
            shape: CustomDecorations.InnerEducationCardShape,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CachedNetworkImage(
                  imageUrl: chapterData.imageSource,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider){
                    return Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight)
                      )
                    );
                  }),
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Глава ${chapterIndex + 1}', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: colorSet.metaColor)),
                        Text(chapterData.title, style: Theme.of(context).textTheme.titleMedium),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: CustomDecorations.progressDataDecoration,
                                padding: EdgeInsets.all(5),
                                  child: Row(
                                children: [
                                  Text(
                                      '${chapterData.passedTests}/${chapterData.testsCount}',
                                      style: Theme.of(context).textTheme.displayMedium),
                                      SizedBox(width: 10),
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset("assets/icons/test-icon.svg", fit: BoxFit.contain))
                                ],
                              )),
                              SizedBox(width: 10),
                              Container(
                                decoration: CustomDecorations.progressDataDecoration,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                children: [
                                  Text(chapterData.chapterScore.toString(),
                                  style: Theme.of(context).textTheme.displayMedium),
                                  SizedBox(width: 10),
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset("assets/icons/crown-icon.svg", fit: BoxFit.contain))
                                ],
                              )
                              ),
                            ],
                          ),
                        ),
                        Text(chapterData.description, style: Theme.of(context).textTheme.bodyMedium)
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
