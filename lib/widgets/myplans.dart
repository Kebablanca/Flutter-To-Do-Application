import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_app/session_manager.dart';
import 'package:to_do_app/widgets/bottom_background_image.dart';

import '../event.dart';
import '../event_service.dart';

class MyPlans extends StatefulWidget {
  const MyPlans({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyPlansState createState() => _MyPlansState();
}

class _MyPlansState extends State<MyPlans> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late TextEditingController _eventController;
  late final ValueNotifier<Map<DateTime, List<Event>>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _getUserEvents();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _eventController = TextEditingController();
    _selectedEvents = ValueNotifier(_getEventsMap());
  }

  Map<DateTime, List<Event>> _getEventsMap() {
    return {...events};
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
      });

      _selectedEvents.value = _getEventsMap();
    }
  }

  Future<void> _getUserEvents() async {
    int userId = int.parse(SessionManager.loggedInUser!.userId);

    List<Event> userEvents =
        await EventService('https://10.0.2.2:7163/api').getUserEvents(userId);

    setState(() {
      for (var event in userEvents) {
        if (events[event.date.toUtc()] == null) {
          events[event.date.toUtc()] = [];
        }
        events[event.date.toUtc()]!.add(event);
      }
    });

    _selectedEvents.value = _getEventsMap();
  }

  void _saveEvent(DateTime selectedDay, String eventTitle) {
    EventService eventService = EventService('https://10.0.2.2:7163/api');
    if (events[selectedDay] == null) {
      events[selectedDay] = [];
    }

    var event = Event(
        date: selectedDay,
        title: eventTitle,
        userId: int.parse(SessionManager.loggedInUser!.userId));
    //useridyi bul ekse
    eventService.postEvent(selectedDay, eventTitle,
        int.parse(SessionManager.loggedInUser!.userId));
    event.toJson();
    events[selectedDay]!.add(event);

    _selectedEvents.value = _getEventsMap();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Event Name"),
                  content: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(controller: _eventController),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        _saveEvent(_selectedDay!, _eventController.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        body: BottomBackgroundImage(
          child: Column(
          children: [
            const SizedBox(height: 50),
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              startingDayOfWeek: StartingDayOfWeek.monday,
              rowHeight: 60,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              onDaySelected: _onDaySelected,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
            ),
            Expanded(
              child: ValueListenableBuilder<Map<DateTime, List<Event>>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  List<Event> selectedDayEvents = value[_selectedDay] ?? [];

                  return ListView.builder(
                    itemCount: selectedDayEvents.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          // ignore: avoid_print
                          onTap: () => print(""),
                          title: Text(selectedDayEvents[index].title),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
