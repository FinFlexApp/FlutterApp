import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/answer-dto.dart';
import 'package:finflex/education/dto/question-dto.dart';
import 'package:finflex/education/dto/question-meta-dto.dart';
import 'package:finflex/education/dto/submit-test-data.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestPage extends StatefulWidget{
  final int testId;

  TestPage({super.key, required this.testId});

  @override
  State<StatefulWidget> createState(){
    return _testPageState();
  }

}

class _testPageState extends State<TestPage>{
  SubmitTestData submitTestData = SubmitTestData();
  List<QuestionMetaDTO> questionsMetaList = [];
  List<QuestionDTO> questionsDataList = [];
  List<Widget> pageViewWidgets = [];
  PageController pageController = PageController();

  void applyAnswerSelection(AnswerSubmition submitData){
    for(int i = 0; i < submitTestData.submittedAnswers.length; i++){
      if(submitTestData.submittedAnswers[i].questionId == submitData.questionId){
        setState(() {
          if(submitData.chosenAnswersIds.isEmpty) {
            submitTestData.submittedAnswers.removeAt(i);
          } else {
            submitTestData.submittedAnswers[i] = submitData;
          }
        });
        return;
      }
    }
    setState(() {
      submitTestData.submittedAnswers.add(submitData);
    });
  }

  Future<List<QuestionMetaDTO>> loadQuestionsList(
      int testId, String token) async {
    var request = await TestsApiService.getQuestionsList(
        testId, token);
    List<dynamic> rawQuestionMetaList = json.decode(request.body);
    List<QuestionMetaDTO> questionMetaList = [];
    for (int i = 0; i < rawQuestionMetaList.length; i++) {
      questionMetaList.add(QuestionMetaDTO.fromJson(rawQuestionMetaList[i]));
    }

    return questionMetaList;
  }

  Future<List<QuestionDTO>> loadQuestionsData(List<QuestionMetaDTO> metaList, String token) async {
    List<QuestionDTO> questionDataList = [];
    for(int i = 0; i < metaList.length; i++){
      var request = await TestsApiService.getQuestion(metaList[i].questionId, token);
      questionDataList.add(QuestionDTO.fromJson(json.decode(request.body)));
    }
    

    return questionDataList;
  }

  Future<void> loadAllTestData(int testId, String token) async{
    questionsMetaList = await loadQuestionsList(testId, token);
    questionsDataList = await loadQuestionsData(questionsMetaList, token);
    
    initPageViewWidgets();
  }

  void initPageViewWidgets(){
    pageViewWidgets = [];
    for(int i = 0; i < questionsDataList.length; i++){
      pageViewWidgets.add(QuestionWidget(questionData: questionsDataList[i], applyHandler: applyAnswerSelection, submition: checkForSubmition(questionsDataList[i].questionId)));
    }
  }

  AnswerSubmition? checkForSubmition(int questionId){
    for(int i = 0; i < submitTestData.submittedAnswers.length; i++){
      if(submitTestData.submittedAnswers[i].questionId == questionId) return submitTestData.submittedAnswers[i];
    }
    return null;
  }

  double calcProgressBar(){
    if(questionsDataList.isNotEmpty) {
      return submitTestData.submittedAnswers.length/questionsDataList.length;
    }
    else{
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  ElevatedButton(onPressed: (){setState(() {

                  });}, child: Container(child: SizedBox(height: 50, width: 50)),),
                  Expanded(child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: const ShapeDecoration(
                        color: ColorStyles.progressBarColor,
                        shape: ContinuousRectangleBorder(
                          side: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(60))
                        )
                      ),
                    child: Stack(
                      children: [
                        LinearProgressIndicator(
                        backgroundColor: ColorStyles.progressBarColor,
                        value: calcProgressBar(),
                        minHeight: 50,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        Center(child: Text('${submitTestData.submittedAnswers.length}/${questionsDataList.length}', style: Theme.of(context).textTheme.headlineLarge))
                      ],
                    )
                  )),
                  ElevatedButton(onPressed: (){setState(() {

                  });}, child: Container(child: SizedBox(height: 50, width: 50)),),
                ],
              ),
            ),
            FutureBuilder(
              future: loadAllTestData(widget.testId, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'),
              builder: (context, snapshot) {
                return Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: pageViewWidgets,
                  ),
                );
              }
            ),
            Container(
              height: 100,
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: ElevatedButton(
                    onPressed: (){pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);},
                    child: Text("Назад"),
                    style: ButtonStyles.mainButtonStyle
                    )),
                  const SizedBox(width: 20),
                  Expanded(child: ElevatedButton(
                    onPressed: (){pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);},
                    child: Text("Далее"),
                    style: ButtonStyles.mainButtonStyle
                    ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

class QuestionWidget extends StatefulWidget{
  AnswerSubmition? submition;
  QuestionDTO questionData;
  Function(AnswerSubmition answersSubmitionData) applyHandler;

  QuestionWidget({super.key, required this.questionData, required this.applyHandler, this.submition});

  @override
  State<StatefulWidget> createState() => _questionWidgetState();
}

class _questionWidgetState extends State<QuestionWidget>{
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: ColorStyles.questionColor,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
              )
            ),
            child: Column(
              children: [
                Text(widget.questionData.questionText, style: Theme.of(context).textTheme.displayLarge),
                CachedNetworkImage(
                  imageUrl: widget.questionData.imageSource,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider){
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fitWidth)
                      )
                      
                    );
                })
              ],
            ),
          ),
          Expanded(child: QuizSelectorWidget(questionId: widget.questionData.questionId, answers: widget.questionData.answers, multipleChoice: widget.questionData.multipleChoice, applyAnswersHandler: widget.applyHandler, submition: widget.submition))
        ],
      ),
    );
  }

}

class QuizSelectorWidget extends StatefulWidget{
  AnswerSubmition? submition;
  List<AnswerDTO> answers;
  int questionId;
  bool multipleChoice;
  Function(AnswerSubmition answerSubmitData) applyAnswersHandler;

  QuizSelectorWidget({super.key, required this.questionId, required this.answers, required this.multipleChoice, required this.applyAnswersHandler, this.submition});
  @override
  State<StatefulWidget> createState() => _quizSelectorState();
}

class _quizSelectorState extends State<QuizSelectorWidget>{
  List<Widget> answersWidgetsCache = [];
  List<bool> answersStates = [];

  @override
  void initState() {
    super.initState();
    if(widget.submition != null){
      mapSubmitionToWidget(widget.submition!);
      return;
    }

    List<Widget> tempAnswerWidgets = [];
    for(int i = 0; i < widget.answers.length; i++){
      answersStates.add(false);
      tempAnswerWidgets.add(AnswerWidget(index: i, isCheckbox: widget.multipleChoice, isSelected: answersStates[i], answerDTO: widget.answers[i], handler: onSelected));
    }
    answersWidgetsCache = tempAnswerWidgets;
  }

  void mapSubmitionToWidget(AnswerSubmition submition){
    List<Widget> tempAnswerWidgets = [];
    for(int i = 0; i < widget.answers.length; i++){
      if(submition.chosenAnswersIds.contains(widget.answers[i].answerId)){
        answersStates.add(true);
        tempAnswerWidgets.add(AnswerWidget(index: i, isCheckbox: widget.multipleChoice, isSelected: answersStates[i], answerDTO: widget.answers[i], handler: onSelected));
      }
      else{
        answersStates.add(false);
      tempAnswerWidgets.add(AnswerWidget(index: i, isCheckbox: widget.multipleChoice, isSelected: answersStates[i], answerDTO: widget.answers[i], handler: onSelected));
      }
    }
    answersWidgetsCache = tempAnswerWidgets;
  }

  void onSelected(bool selection, int index){
    setState(() {
      if(!widget.multipleChoice){
        for(int i = 0; i < widget.answers.length; i++) {
          answersStates[i] = false;
        }
      }
      answersStates[index] = selection;
      List<Widget> tempAnswerWidgets = [];
      for(int i = 0; i < widget.answers.length; i++){
        tempAnswerWidgets.add(AnswerWidget(index: i, isCheckbox: widget.multipleChoice, isSelected: answersStates[i], answerDTO: widget.answers[i], handler: onSelected));
      }
      answersWidgetsCache = tempAnswerWidgets;
    });
    List<int> chosenAnswersIds = [];
    for(int i = 0; i < widget.answers.length; i++){
      if(answersStates[i]) chosenAnswersIds.add(widget.answers[i].answerId);
    }
    widget.applyAnswersHandler(AnswerSubmition(questionId: widget.questionId, chosenAnswersIds: chosenAnswersIds));
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: answersWidgetsCache.length,
        itemBuilder:(context, index) {
          return Column(
            children: [
              answersWidgetsCache[index],
              SizedBox(height: 20)
            ],
          );
        },
      ),
    );
  }

}

class AnswerWidget extends StatelessWidget{
  final int index;
  final bool isCheckbox;
  final bool isSelected;
  final AnswerDTO answerDTO;

  final Function(bool selected, int index) handler;

  const AnswerWidget({super.key, required this.index, required this.isCheckbox, required this.isSelected, required this.answerDTO, required this.handler});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handler(!isSelected, index),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: ColorStyles.questionColor,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(answerDTO.answerText, style: Theme.of(context).textTheme.titleMedium),
            Container(
              decoration: ShapeDecoration(
                color: isSelected ? Colors.white : Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
              child: SizedBox(height: 30, width: 30),
            )
          ],),
      ),
    );
  }

}