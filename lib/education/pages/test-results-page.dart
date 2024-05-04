import 'package:finflex/education/dto/results-dto.dart';
import 'package:flutter/material.dart';

class TestResultsPage extends StatelessWidget{
  TestResultsDTO data;
  Function refreshCallBack;
  
  TestResultsPage({super.key, required this.data, required this.refreshCallBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Image.asset('assets/icons/crown-icon.png'),
          Text("Вы набрали ${data.rightPercent * 100}% верных ответов!"),
          Text("Вернитесь в коноху!!!"),
          ElevatedButton(
            onPressed: (){
              refreshCallBack();
              Navigator.pop(context);
            },
            child: Text("Вернуться к выбору теста")
          )
        ],
      ),
    );
  }

}