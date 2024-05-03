class AnswerDTO{
  final int answerId;
  final String answerText;
  final bool isRight;
  final String answerAttachment;

  factory AnswerDTO.fromJson(Map<String, dynamic> json) => AnswerDTO(
    answerId: json['answers_id'],
    answerText: json['answer_text'],
    answerAttachment: json['answer_attachment'],
    isRight: json['isRight']
  );

  static List<AnswerDTO> listFromJson(List<dynamic> json){
    List<AnswerDTO> list = [];
    for(int i = 0; i < json.length; i++){
      list.add(AnswerDTO.fromJson(json[i]));
    }
    return list;
  } 

  AnswerDTO({required this.answerId,
              required this.answerText,
              required this.isRight,
              required this.answerAttachment});
}