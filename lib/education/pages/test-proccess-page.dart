import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/tests-api.dart';
import 'package:finflex/education/dto/answer-dto.dart';
import 'package:finflex/education/dto/question-dto.dart';
import 'package:finflex/education/dto/question-meta-dto.dart';
import 'package:finflex/education/dto/results-dto.dart';
import 'package:finflex/education/dto/submit-test-data.dart';
import 'package:finflex/education/pages/test-results-page.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestPage extends StatefulWidget{
  final int testId;
  final Function refreshCallBack;

  TestPage({super.key, required this.testId, required this.refreshCallBack});

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
  int pageIndex = 0;

  void initState(){
    submitTestData.testId = widget.testId;
  }

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
      int testId, ProfileData profileData) async {
    var token = profileData.token!;

    var request = await TestsApiService.getQuestionsList(
        testId, token);
    List<dynamic> rawQuestionMetaList = json.decode(request.body);
    List<QuestionMetaDTO> questionMetaList = [];
    for (int i = 0; i < rawQuestionMetaList.length; i++) {
      questionMetaList.add(QuestionMetaDTO.fromJson(rawQuestionMetaList[i]));
    }

    return questionMetaList;
  }

  Future<List<QuestionDTO>> loadQuestionsData(List<QuestionMetaDTO> metaList, ProfileData profileData) async {
    var token = profileData.token!;

    List<QuestionDTO> questionDataList = [];
    for(int i = 0; i < metaList.length; i++){
      var request = await TestsApiService.getQuestion(metaList[i].questionId, token);
      questionDataList.add(QuestionDTO.fromJson(json.decode(request.body)));
    }
    

    return questionDataList;
  }

  Future<void> loadAllTestData(int testId, ProfileData profileData) async{
    if(questionsDataList.isEmpty && questionsMetaList.isEmpty){
      questionsMetaList = await loadQuestionsList(testId, profileData);
      questionsDataList = await loadQuestionsData(questionsMetaList, profileData);
    }
    
    
    initPageViewWidgets();
  }

  void initPageViewWidgets(){
    pageViewWidgets = [];
    for(int i = 0; i < questionsDataList.length; i++){
      pageViewWidgets.add(QuestionWidget(questionData: questionsDataList[i], applyHandler: applyAnswerSelection, submition: checkForSubmition(questionsDataList[i].questionId)));
    }
    pageViewWidgets.add(TestConfirmationWidget(questionsAnswered: submitTestData.submittedAnswers.length, questionsCount: questionsDataList.length));
  }

  Future<void> sendResults(SubmitTestData data, ProfileData profileData) async{
    var token = profileData.token!;

    var request = await TestsApiService.SendResults(data, token);
    var results = TestResultsDTO.fromJson(json.decode(request.body));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Theme(data: CustomThemes.resultsTheme, child: TestResultsPage(data: results, refreshCallBack: widget.refreshCallBack))),
    );
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

  void swipePage(bool direction){
    setState(() {
      if(direction){
        pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        pageIndex++;
        if(pageIndex > pageViewWidgets.length - 1) pageIndex = pageViewWidgets.length - 1;
      }
      else{
        pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        pageIndex--;
        if(pageIndex < 0) pageIndex = 0;
      }
    });
  }

  void selectPage(int pageIndex) async{
    await pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  Widget showContextButtons(){
    if (questionsDataList.isNotEmpty && pageController.hasClients){
      if(pageIndex < pageViewWidgets.length - 1){
        return Container(
            height: 100,
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: (){ swipePage(false); },
                  child: Text("Назад"),
                  style: ButtonStyles.mainButtonStyle
                  )),
                const SizedBox(width: 20),
                Expanded(child: ElevatedButton(
                  onPressed: (){ swipePage(true); },
                  child: Text("Далее"),
                  style: ButtonStyles.mainButtonStyle
                  ))
              ],
            ),
          );
      }
      else{
        return Container(
            height: 100,
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: () {swipePage(false);},
                  child: Text("Назад"),
                  style: ButtonStyles.mainButtonStyle
                  )),
                const SizedBox(width: 20),
                Expanded(child: ElevatedButton(
                  onPressed: (){
                    sendResults(submitTestData, AppProcessDataProvider.of(context)!.profileData);
                  },
                  child: Text("Отправить результаты"),
                  style: ButtonStyles.mainButtonStyle
                  ))
              ],
            ),
          );
    }
    }
    else return Container(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    submitTestData.userId = AppProcessDataProvider.of(context)!.profileData.userId!;
    return SafeArea(
      child: Container(
        color: ColorStyles.mainBackgroundColor,
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: loadAllTestData(widget.testId, AppProcessDataProvider.of(context)!.profileData),
          builder: (context, snapshot) {
            return Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: (){ 
                        showModalBottomSheet(
                          
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => TestModalSheet(questionsMeta: questionsMetaList, submitTestData: submitTestData, pageSelector: selectPage));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                      child: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/icons/menu-icon.png'))),
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
                        alignment: Alignment.center,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                      onPressed: (){
                      Navigator.pop(context);
                    }, child: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/icons/close-icon.png'))),
                  ],
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: pageViewWidgets,
                  ),
                ),
                showContextButtons()
              ],
            );
          }
        ),
      ),
    );
  }

}

class TestConfirmationWidget extends StatefulWidget{
  int questionsAnswered;
  int questionsCount;

  TestConfirmationWidget({super.key, required this.questionsAnswered, required this.questionsCount});

  @override
  State<StatefulWidget> createState() => _testConfirmationState();
  
}

class _testConfirmationState extends State<TestConfirmationWidget>{

  Widget summaryMessageBuilder(){
    if(widget.questionsAnswered == widget.questionsCount){
      return Column(
        children: [
          Image.asset('assets/images/answered-test-image.png'),
          SizedBox(height: 30),
          Center(child: Text("Вы ответили на все вопросы!", style: Theme.of(context).textTheme.titleMedium)),
          Center(child: Text("Хотите завершить тест?", style: Theme.of(context).textTheme.bodyMedium))
        ],
      );
    }
    else{
      return Column(
        children: [
          Image.asset('assets/images/thinking-image.png'),
          SizedBox(height: 30),
          Center(child: Text('Вы ответили на ${widget.questionsAnswered} вопросов из ${widget.questionsCount}', style: Theme.of(context).textTheme.titleMedium)),
          Center(child: Text('Вы уверены, что хотите завершить тест?', style: Theme.of(context).textTheme.bodyMedium))
        ],
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: summaryMessageBuilder(),
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
                Text(widget.questionData.questionText, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 20),
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
  ScrollController scrollController = ScrollController();

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
      thickness: 5,
      thumbVisibility: true,
      interactive: true,
      radius: Radius.circular(10),
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: answersWidgetsCache.length,
        itemBuilder:(context, index) {
          return Column(
            children: [
              answersWidgetsCache[index],
              SizedBox(height: 15)
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(answerDTO.answerText, style: Theme.of(context).textTheme.bodyMedium)),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: ShapeDecoration(
                color: isSelected ? Colors.white : Colors.black,
                shape: isCheckbox ? ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))) : CircleBorder(),
              ),
              child: SizedBox(height: 30, width: 30),
            ),
          ],),
      ),
    );
  }

}

class TestModalSheet extends StatelessWidget{
  final List<QuestionMetaDTO> questionsMeta;
  final SubmitTestData submitTestData;
  final Function(int) pageSelector;

  TestModalSheet({super.key, required this.questionsMeta, required this.submitTestData, required this.pageSelector});
  
  bool isAnswered(int index){
    for(int i = 0; i < submitTestData.submittedAnswers.length; i++){
      if(submitTestData.submittedAnswers[i].questionId == questionsMeta[index].questionId) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      builder: (context, builder) => Container(
        padding: EdgeInsets.all(20),
        decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          color: Colors.white
        ),
        child: Column(
          children: [
            Text("Вопросы теста", style: TextStyle(fontSize: 25, color: Colors.black)),
            Expanded(
              child: Scrollbar(
                thickness: 5,
                child: ListView.builder(
                  itemCount: questionsMeta.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            side: BorderSide(width: 2)
                          )
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Номер вопроса
                            isAnswered(index) ?
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: ShapeDecoration(
                                color: Colors.green,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                )
                              ),
                              child: Row(
                                children: [
                                  Text(questionsMeta[index].questionSequence.toString(), style: TextStyle(color: Colors.black)),
                                  SizedBox(width: 10),
                                  Icon(Icons.check)
                                ],
                              ),
                            ) :
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 129, 166, 131),
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                )
                              ),
                              child: Row(
                                children: [
                                  Text(questionsMeta[index].questionSequence.toString(), style: TextStyle(color: Colors.black)),
                                  SizedBox(width: 10),
                                  Icon(Icons.close)
                                ],
                              ),
                            ),
                            // Текст вопроса
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(questionsMeta[index].questionText, style: TextStyle(color: Colors.black, fontSize: 20)),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyles.mainButtonStyle,
                              onPressed: (){
                                pageSelector(index);
                                Navigator.pop(context);
                              },
                              child: Text("Перейти"))
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  
}