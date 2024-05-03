class ChapterTestDTO{
  final String imageSource;
  final bool isPassed;
  final bool isUnlocked;
  final int userScore;
  final int maxScore;
  final int questionsCount;
  final int testId;
  final String title;

  ChapterTestDTO({required this.imageSource,
                  required this.isPassed,
                  required this.isUnlocked,
                  required this.userScore,
                  required this.maxScore,
                  required this.questionsCount,
                  required this.testId,
                  required this.title});

  factory ChapterTestDTO.fromJson(Map<String, dynamic> json) => ChapterTestDTO(
    imageSource: json['img_src'],
    isPassed: json['is_passed'],
    isUnlocked: json['is_unlocked'],
    userScore: json['user_score'],
    maxScore: json['max_score'],
    questionsCount: json['questions_count'],
    testId: json['test_id'],
    title: json['title']
  );
}