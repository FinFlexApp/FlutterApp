import 'package:finflex/education/dto/answer-dto.dart';

class QuestionDTO{
  final int questionId;
  final int questionSeq;
  final String questionText;
  final String imageSource;
  final bool multipleChoice;
  final List<AnswerDTO> answers;

  factory QuestionDTO.fromJson(Map<String, dynamic> json) => QuestionDTO(
    questionId: json['id'],
    questionSeq: json['question_seq'],
    questionText: json['question_text'],
    imageSource: json['question_attachment'],
    multipleChoice: json['multiple_choice'],
    answers: AnswerDTO.listFromJson(json['answers'])
  );

  QuestionDTO({required this.questionId,
                required this.questionSeq,
                required this.imageSource,
                required this.multipleChoice,
                required this.answers,
                required this.questionText});
}