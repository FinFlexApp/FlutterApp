class ChapterDTO{
  final int chapterId;
  final int chapterScore;
  final String description;
  final String imageSource;
  final int passedTests;
  final int testsCount;
  final String title;
  final bool isUnlocked;

  ChapterDTO({required this.chapterId,
              required this.chapterScore,
              required this.description,
              required this.imageSource,
              required this.passedTests,
              required this.testsCount,
              required this.title,
              required this.isUnlocked});

  factory ChapterDTO.fromJson(Map<String, dynamic> json) => ChapterDTO(
    chapterId: json['chapter_id'],
    chapterScore: json['chapter_score'].toInt(),
    description: json['description'],
    imageSource: json['img_src'],
    passedTests: json['passed_tests'],
    testsCount: json['tests_count'],
    title: json['title'],
    isUnlocked: json['is_unlocked']
  );
}