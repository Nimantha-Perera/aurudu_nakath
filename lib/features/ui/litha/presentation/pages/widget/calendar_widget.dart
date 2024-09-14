import 'package:aurudu_nakath/features/ui/litha/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';



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

    // if (_events.isEmpty) {
    //   _events = {
    //     DateTime.now().subtract(Duration(days: 2)): [Event('උදෑසන කෑම', Colors.blue)],
    //     DateTime.now(): [Event('සාමාන්ය දිනය', Colors.green), Event('සතිඅන්ත දිනය', Colors.orange)],
    //     DateTime.now().add(Duration(days: 3)): [Event('උත්සව දිනය', Colors.red)],
    //   };
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          _buildCalendar(),
          const Divider(height: 1),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy', 'si_LK').format(_focusedDay),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Theme.of(context).primaryColorLight),
                onPressed: () => _onPageChanged(_focusedDay.subtract(Duration(days: 30))),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColorLight),
                onPressed: () => _onPageChanged(_focusedDay.add(Duration(days: 30))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: (day) => _events[day] ?? [],
        locale: 'si_LK',
        onDaySelected: _onDaySelected,
        onPageChanged: _onPageChanged,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: Colors.red),
          outsideDaysVisible: false,
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
        headerVisible: false,
      ),
    );
  }

  Widget _buildEventsMarker(List events) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
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
      height: 200,
      child: events.isEmpty
          ? Center(
              child: Text(
                'මෙම දිනයේ කිසිදු උත්සවයක් නොමැත',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index] as Event;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: event.color,
                      child: Icon(Icons.event, color: Colors.white),
                    ),
                    title: Text(
                      event.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.more_vert),
                    onTap: () => _showEventDetails(event),
                  ),
                );
              },
            ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Text('උත්සව විස්තර මෙතැන දැක්විය හැක.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('වසන්න'),
          ),
        ],
      ),
    );
  }
}