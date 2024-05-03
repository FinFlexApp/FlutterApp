class SubmitTestData{
  int userId = 0;
  int testId = 0;
  List<AnswerSubmition> submittedAnswers = [];
}

class AnswerSubmition{

  int questionId = 0;
  List<int> chosenAnswersIds = [];
  
  AnswerSubmition({required this.questionId,required this.chosenAnswersIds});
}