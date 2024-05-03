class QuestionMetaDTO{
  final int questionId;
  final int questionSequence;
  final String questionText;

  QuestionMetaDTO({required this.questionId,
                    required this.questionSequence,
                    required this.questionText});

  factory QuestionMetaDTO.fromJson(Map<String, dynamic> json) => QuestionMetaDTO(
    questionId: json['question_id'],
    questionSequence: json['question_seq'],
    questionText: json['question_text']
  );


}