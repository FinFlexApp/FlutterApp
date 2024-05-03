import 'package:finflex/chat/pages/chat-page.dart';
import 'package:finflex/education/pages/chapters-page.dart';
import 'package:finflex/news/pages/news-page.dart';
import 'package:finflex/leaderbboard/pages/leaderboard-page.dart';
import 'package:finflex/profile/pages/profile-page.dart';
import 'package:finflex/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FinFlexApp extends StatefulWidget{
  const FinFlexApp({super.key});

  @override
  State<StatefulWidget> createState()=> _finFlexAppState();
}

class _finFlexAppState extends State<FinFlexApp>{
  int currentPageIndex = 2;


  void setPageIndex(int index){
    setState(() {
      currentPageIndex = index;
    });
  }

  Widget pageSelector(int index){
    switch(index){
      case 0:
        return const ChaptersPage();
      case 1:
        return NewsPage();
      case 2:
        return ChatBotPage();
      case 3:
        return LeaderBoardPage();
      case 4:
        return ProfilePage();
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
      appBar: AppBar(title: Container(
        padding: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: ColorStyles.appBarMainColor,
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)))
        ),

        child: Text("Главы", style: Theme.of(context).textTheme.headlineMedium,)), backgroundColor: Colors.transparent,),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          clipBehavior: Clip.hardEdge, //or better look(and cost) using Clip.antiAlias,
          decoration: const ShapeDecoration(
            color: Color.fromARGB(255, 34, 58, 88),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)))
            ),
          child: NavigationBar(
            //indicatorShape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
            selectedIndex: currentPageIndex,
            onDestinationSelected: setPageIndex,
            indicatorColor: Colors.green,
            backgroundColor: const Color.fromARGB(255, 34, 58, 88),
              destinations: [
                NavigationDestination(icon: Image.asset('assets/icons/test-nav-icon.png'), label: 'Тесты'),
                NavigationDestination(icon: Image.asset('assets/icons/news-nav-icon.png'), label: 'Новости'),
                NavigationDestination(icon: Image.asset('assets/icons/bot-nav-icon.png'), label: 'Чат-бот'),
                NavigationDestination(icon: Image.asset('assets/icons/leader-nav-icon.png'), label: 'Лидеры'),
                NavigationDestination(icon: Image.asset('assets/icons/leader-nav-icon.png'), label: 'Профиль')
              ],
            ),
        ),
      ),
    );
  }

}


class CustomizedAppBarManager{
  
}