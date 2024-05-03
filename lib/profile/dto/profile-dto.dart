class ProfileDTO{
  final int userId;
  final String nickname;
  final String imageSource;
  final String firstName;
  final String surName;
  //final DateTime regDate;
  final int score;

  ProfileDTO({required this.userId,
            required this.imageSource,
            required this.firstName,
            required this.nickname,
            required this.surName,
            //required this.regDate,
            required this.score});

  factory ProfileDTO.fromJson(Map<String, dynamic> json) => ProfileDTO(
    userId: json['userId'],
    surName: json['surname'],
    score: json['score'].toInt(),
    nickname: json['nickname'],
    firstName: json['name'],
    imageSource: json['img_src']
  );


}