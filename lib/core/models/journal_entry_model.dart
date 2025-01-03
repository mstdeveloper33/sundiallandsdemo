class JournalEntry {
  final int? id;
  final String text;
  final String mood;
  final String date;

  JournalEntry({
    this.id,
    required this.text,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'mood': mood,
      'date': date,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      text: json['text'],
      mood: json['mood'],
      date: json['date'],
    );
  }
}