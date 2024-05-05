import 'package:finflex/education/dto/results-dto.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestResultsPage extends StatelessWidget{
  TestResultsDTO data;
  Function refreshCallBack;
  
  TestResultsPage({super.key, required this.data, required this.refreshCallBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          color: ColorStyles.mainBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                child: Image.asset('assets/images/cup-image.png')),
              Text("${(data.rightPercent * 100).toStringAsFixed(1)}% верных ответов приносят вам...", style: Theme.of(context).textTheme.labelMedium),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: CustomDecorations.progressDataDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/icons/crown-icon.svg', height: 50),
                    Text("${data.points} корон!", style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Color.fromARGB(255, 170, 91, 0))),
                    SvgPicture.asset('assets/icons/crown-icon.svg', height: 50),
                  ],
                )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  refreshCallBack();
                  Navigator.pop(context);
                },
                style: ButtonStyles.mainButtonStyle,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Вернуться к выбору теста"),
                )
              )
            ],
          ),
        ),
      );
  }

}