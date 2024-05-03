class MessageDTO{
  final DateTime date;
  final bool isReply;
  final String message;

    MessageDTO({required this.date,
              required this.isReply,
              required this.message});

  factory MessageDTO.fromJson(Map<String, dynamic> json) => MessageDTO(
    date: DateTime.parse(json['date']),
    message: json['message'],
    isReply: json['isReply'],
  );
}