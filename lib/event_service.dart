import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_app/event.dart';

class EventService {
  String apiUrl;

  EventService(this.apiUrl);

  Future<Event> postEvent(
      DateTime selectedDay, String eventTitle, int userId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/Event'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': selectedDay.toIso8601String(),
        'title': eventTitle,
        'userId': userId
      }),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      // ignore: avoid_print
      print(response.statusCode);
      throw Exception('Failed ');
    }
  }

  Future<List<Event>> getUserEvents(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/Event/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = jsonDecode(response.body);
      List<Event> events =
          decodedResponse.map((e) => Event.fromJson(e)).toList();
      return events;
    } else {
      throw Exception('Failed to get user events');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final apiUrl = 'https://10.0.2.2:7163/api/Event/$eventId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        // Başarı durumunda
        print('Event successfully deleted');
      } else {
        // Hata durumunda
        print('Failed to delete event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Hata durumunda
      print('Error deleting event: $e');
    }
  }
}
