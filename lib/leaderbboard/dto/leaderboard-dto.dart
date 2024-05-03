class LeaderDTO{
  final String firstName;
  final String surName;
  final String imageSource;
  final int testsPassed;
  final int userId;
  final int score;
  final String nickName;

  LeaderDTO({required this.firstName,
                required this.surName,
                required this.imageSource,
                required this.testsPassed,
                required this.userId,
                required this.score,
                required this.nickName});

  factory LeaderDTO.fromJson(Map<String, dynamic> json) => LeaderDTO(
    firstName: json['firstname'],
    surName: json['surname'],
    nickName: json['nickname'],
    imageSource: json['img_src'],
    score: json['score'].toInt(),
    testsPassed: json['tests_passed'],
    userId: json['user_id']
  );
}