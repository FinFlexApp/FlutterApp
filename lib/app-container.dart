import 'package:finflex/chat/pages/chat-page.dart';
import 'package:finflex/education/pages/chapters-page.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/news/pages/news-page.dart';
import 'package:finflex/leaderboard/pages/leaderboard-page.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/pages/profile-page.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FinFlexApp extends StatefulWidget{

  FinFlexApp({super.key});

  @override
  State<StatefulWidget> createState()=> _finFlexAppState();
}

class _finFlexAppState extends State<FinFlexApp>{
  int currentPageIndex = 0;
  String currentAppBarLabel = 'Тестирование. Главы';

  @override
  void initState() {
    setPageIndex(0);
    super.initState();
  }

  void setPageIndex(int index){
    setState(() {
      currentPageIndex = index;
    });
  }

  Widget pageSelector(int index){
    switch(index){
      case 0:
        currentAppBarLabel = "Тестирование. Главы";
        return Theme(
          data: CustomThemes.chaptersTheme,
          child: ChaptersPage());
      case 1:
        currentAppBarLabel = "Новости";
        return Theme(
          data: CustomThemes.newsTheme,
          child: NewsPage());
      case 2:
        currentAppBarLabel = "Чат-бот Виталий";
        return Theme(
          data: CustomThemes.botTheme,
          child: ChatBotPage());
      case 3:
        currentAppBarLabel = "Таблица лидеров";
        return Theme(
          data: CustomThemes.leadersTheme,
          child: LeaderBoardPage());
      case 4:
        currentAppBarLabel = "Профиль";
        return Theme(
          data: CustomThemes.profileTheme,
          child: ProfilePage());
    }
    return NewsPage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 22, 33),
      
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: pageSelector(currentPageIndex),
      )),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
        padding: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: ColorStyles.appBarMainColor,
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)))
        ),
    
        child: Text(currentAppBarLabel, style: Theme.of(context).textTheme.headlineMedium,)),
        backgroundColor: Colors.transparent,),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const ShapeDecoration(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)))
          ),
          child: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 34, 58, 88),
            selectedItemColor: Colors.green,
            currentIndex: currentPageIndex,
            onTap: setPageIndex,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/test-nav-icon.png'),
                label: 'Тесты',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/news-nav-icon.png'),
                label: 'Новости',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/bot-nav-icon.png'),
                label: 'Чат-бот',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/leader-nav-icon.png'),
                label: 'Лидеры',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/leader-nav-icon.png'),
                label: 'Профиль',
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class CustomizedAppBarManager{
  
}