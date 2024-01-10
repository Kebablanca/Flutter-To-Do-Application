import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/alarm_service.dart';
import 'package:to_do_app/session_manager.dart';
import 'package:to_do_app/widgets/bottom_background_image.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _currentTime = '';
  TimeOfDay _selectedTime = TimeOfDay.now();
  final int _selectedDay = 1;
  bool _isAlarmSet = false;
  List<Alarm> _alarms = [];
  final ApiProvider apiProvider = ApiProvider('https://10.0.2.2:7163/api');

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
      if (_isAlarmSet) {
        checkAlarm();
      }
    });
    fetchAlarms();
  }

  Future<void> fetchAlarms() async {
    try {
      final List<Alarm> alarms = await apiProvider.getAlarms();
      setState(() {
        _alarms = alarms;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching alarms: $e');
    }
  }

  void showAlarmNotification(BuildContext context, Alarm alarm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alarm Çalıyor!'),
          content: Column(
            children: [
              Text(
                  'Alarm Zamanı: ${DateFormat('HH:mm').format(alarm.alarmTime)}'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await deleteAlarm(alarm);
                    },
                    child: const Text('Kapat'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      extendAlarm(alarm, 10);
                    },
                    child: const Text('10 Dakika Ertele'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void extendAlarm(Alarm alarm, int minutes) async {
    try {
      await apiProvider.extendAlarm(alarm.id!, minutes);
      _alarms = await apiProvider.getAlarms();
    } catch (e) {
      // ignore: avoid_print
      print('Error extending alarm: $e');
    }
  }

  void checkAlarm() {
    TimeOfDay now = TimeOfDay.now();
    for (Alarm alarm in _alarms) {
      if (now.hour == alarm.alarmTime.hour &&
          now.minute == alarm.alarmTime.minute &&
          DateTime.now().weekday == alarm.day &&
          alarm.isSet) {
        showAlarmNotification(context, alarm);

        setState(() {
          alarm.isSet = false;
        });
      }
    }
  }

  Future<void> setAlarm() async {

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (selectedTime != null) {
      DateTime now = DateTime.now();
      DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      await apiProvider.createAlarm(Alarm(
        alarmTime: selectedDateTime,
        day: _selectedDay,
        isSet: true,
        userId:int.parse(SessionManager.loggedInUser!.userId),

      ));

      await fetchAlarms();

      setState(() {
        _selectedTime = selectedTime;
        _isAlarmSet = true; 
      });
    }
  }

  Future<void> editAlarm(Alarm alarm) async {
    TimeOfDay? editedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: alarm.alarmTime.hour, minute: alarm.alarmTime.minute),
    );

    if (editedTime != null) {
      setState(() async {
        alarm.alarmTime = DateTime(
          alarm.alarmTime.year,
          alarm.alarmTime.month,
          alarm.alarmTime.day,
          editedTime.hour,
          editedTime.minute,
        );

        try {
          await apiProvider.updateAlarm(alarm);
          await fetchAlarms();
        } catch (e) {
          // ignore: avoid_print
          print('Error editing alarm: $e');
        }
      });
    }
  }

  Future<void> deleteAlarm(Alarm alarm) async {
    try {
      await apiProvider.deleteAlarm(alarm.id!);
      setState(() {
        _alarms.remove(alarm);
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting alarm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm'),
      ),
      body: BottomBackgroundImage(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Şu anki zaman:',
              ),
              Text(
                _currentTime,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: setAlarm,
                child: const Text('Alarmı Ayarla'),
              ),
              const SizedBox(height: 20),
              Text(
                'Kurulan Alarmlar:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _alarms.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: GestureDetector(
                        onTap: () => editAlarm(_alarms[index]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Alarm ${index + 1}: ${DateFormat('HH:mm').format(_alarms[index].alarmTime)}',
                              style: TextStyle(
                                color: _alarms[index].isSet
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Row(
                              children: [
                                DropdownButton<int>(
                                  value: _alarms[index].day,
                                  onChanged: (int? newValue) async {
                                    setState(() {
                                      _alarms[index].day = newValue!;
                                    });

                                    try {
                                      await apiProvider
                                          .updateAlarm(_alarms[index]);
                                    } catch (e) {
                                      // ignore: avoid_print
                                      print('Error updating alarm day: $e');
                                    }
                                  },
                                  items: List.generate(
                                    7,
                                    (index) => DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Text(_getDayName(index + 1)),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await deleteAlarm(_alarms[index]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Pazartesi';
      case 2:
        return 'Salı';
      case 3:
        return 'Çarşamba';
      case 4:
        return 'Perşembe';
      case 5:
        return 'Cuma';
      case 6:
        return 'Cumartesi';
      case 7:
        return 'Pazar';
      default:
        return '';
    }
  }
}
