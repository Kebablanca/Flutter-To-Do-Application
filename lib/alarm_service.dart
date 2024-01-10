import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl;

  ApiProvider(this.baseUrl);

  Future<List<Alarm>> getAlarms() async {
    final response = await http.get(Uri.parse('$baseUrl/Alarm'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Alarm.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load alarms');
    }
  }

Future<void> createAlarm(Alarm alarm) async {
  final response = await http.post(
    Uri.parse('$baseUrl/Alarm'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"alarm": alarm.toJson()}), 
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create alarm');
  }
}

  Future<void> updateAlarm(Alarm alarm) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Alarm/${alarm.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(alarm.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update alarm');
    }
  }

  Future<void> deleteAlarm(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Alarm/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete alarm');
    }
  }

  Future<void> extendAlarm(int id, int minutes) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Alarm/$id/extend'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'minutes': minutes}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to extend alarm');
    }
  }
}

class Alarm {
  DateTime alarmTime;
  int day;
  bool isSet;
  int? id;
  int? userId;

  Alarm({required this.alarmTime, required this.day, this.isSet = false, this.id, required userId});

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      alarmTime: DateTime.parse(json['alarmTime']),
      day: json['day'],
      isSet: json['isSet'],
      id: json['id'],
      userId:json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarmTime': alarmTime.toIso8601String(),
      'day': day,
      'isSet': isSet,
      'id': id,
      'userId':userId
    };
  }
}
