class TestDTO{
  final int testId;
  final String title;
  final int userScore;
  final int maxScore;
  final String imageSource;
  final bool isPassed;
  final bool isUnlocked;
  final int questionsCount;

  TestDTO({required this.testId,
        required this.title,
        required this.userScore,
        required this.maxScore,
        required this.imageSource,
        required this.isPassed,
        required this.isUnlocked,
        required this.questionsCount});

  factory TestDTO.fromJson(Map<String, dynamic> json) => TestDTO(
    testId: json['test_id'],
    title: json['title'],
    userScore: json['user_score'].toInt(),
    maxScore: json['max_score'],
    imageSource: json['img_src'],
    isPassed: json['is_passed'],
    isUnlocked: json['is_unlocked'],
    questionsCount: json['questions_count']
  );
}