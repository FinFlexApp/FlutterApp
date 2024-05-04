class TestResultsDTO{
  final int points;
  final double rightPercent;
  final int testId;
  

  factory TestResultsDTO.fromJson(Map<String, dynamic> json) => TestResultsDTO(
    points: json['points'].toInt(),
    rightPercent: json['right_percent'],
    testId: json['test_id']
  );

  TestResultsDTO({required this.points,
                  required this.rightPercent,
                  required this.testId});


}