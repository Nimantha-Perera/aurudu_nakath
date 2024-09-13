import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/event.dart';

class CalendarWidget extends StatefulWidget {
  final Map<DateTime, List<Event>> events;

  const CalendarWidget({Key? key, required this.events}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = widget.events;

    // Add sample events if the events map is empty
    if (_events.isEmpty) {
      _events = {
        DateTime.now().subtract(Duration(days: 2)): [Event('උදෑසන කෑම', Colors.blue)],
        DateTime.now(): [Event('සාමාන්ය දිනය', Colors.green), Event('සතිඅන්ත දිනය', Colors.orange)],
        DateTime.now().add(Duration(days: 3)): [Event('උත්සව දිනය', Colors.red)],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _events[day] ?? [],
            locale: 'si_LK',
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(events),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      width: 16,
      height: 16,
      child: Center(
        child: Stack(
          children: events.take(3).map((event) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: (event as Event).color,
                radius: 2,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final events = _events[_selectedDay] ?? [];
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index] as Event;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: event.color,
            ),
            title: Text(event.title),
          );
        },
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay, DateTime? focusedDayHint) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }
}

class Event {
  final String title;
  final Color color;

  Event(this.title, this.color);
}