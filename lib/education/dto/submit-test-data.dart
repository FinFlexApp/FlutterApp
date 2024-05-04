class SubmitTestData{
  int userId = 0;
  int testId = 0;
  List<AnswerSubmition> submittedAnswers = [];
}

class AnswerSubmition{

  int questionId = 0;
  List<int> chosenAnswersIds = [];
  
  AnswerSubmition({required this.questionId,required this.chosenAnswersIds});

  static List<Map<String, dynamic>> ToListMap(List<AnswerSubmition> data){
    List<Map<String, dynamic>> result = [];

    for(int i = 0; i < data.length; i++){
      result.add({
        'question_id': data[i].questionId,
        'chosen_answers_ids': data[i].chosenAnswersIds
      });
    }

    return result;
  }
}