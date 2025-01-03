
class MotivationalMessage {
  final String message;
  final DateTime date;

  MotivationalMessage({
    required this.message,
    required this.date,
  });

  factory MotivationalMessage.fromJson(Map<String, dynamic> json) {
    return MotivationalMessage(
      message: json['message'],
      date: DateTime.parse(json['date']),
    );
  }
}
