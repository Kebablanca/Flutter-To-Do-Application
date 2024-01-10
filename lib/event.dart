// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Event {
  final String title;
  final DateTime date;
  final int userId;
  Event({
    required this.title,
    required this.date,
    required this.userId,
  });

  Event copyWith({
    String? title,
    DateTime? date,
    int? userId,
  }) {
    return Event(
      title: title ?? this.title,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      title: map['title'] as String,
      date: DateTime.parse(map['date']),
      userId: map['userId'] as int,
    );
  }

  String toJson() => json.encode(toMap());



  @override
  String toString() => 'Event(title: $title, date: $date, userId: $userId)';

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.date == date &&
      other.userId == userId;
  }

  @override
  int get hashCode => title.hashCode ^ date.hashCode ^ userId.hashCode;
}
