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

  final List<String> weekdayNames = [
    'ඉරිදා    ',
    'සඳුදා    ',
    'අඟහ     ',
    'බදාදා    ',
    'බ්‍රහස්   ',
    'සිකු     ',
    'සෙන     ',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? Color(0xFF1E1E1E)  // Darker background for dark mode
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(isDark),
          _buildCalendar(isDark),
          _buildEventList(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark ? [
            Color(0xFF2C3E50),  // Dark blue-grey gradient
            Color(0xFF3498DB),
          ] : [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy', 'si_LK').format(_focusedDay),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => _onPageChanged(_focusedDay.subtract(const Duration(days: 30))),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => _onPageChanged(_focusedDay.add(const Duration(days: 30))),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Color(0xFF2A2A2A)  // Slightly lighter than background
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ] : [],
      ),
      margin: const EdgeInsets.all(16),
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
            color: isDark ? Color(0xFF3498DB) : Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: (isDark ? Color(0xFF3498DB) : Theme.of(context).primaryColor)
                .withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(
            color: isDark ? Color(0xFFFF6B6B) : Colors.red,
          ),
          outsideDaysVisible: false,
          cellMargin: const EdgeInsets.all(6),
          defaultTextStyle: TextStyle(
            color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            final index = day.weekday % 7;
            final isWeekend = day.weekday == DateTime.sunday || 
                            day.weekday == DateTime.saturday;
            return Center(
              child: Text(
                weekdayNames[index],
                style: TextStyle(
                  color: isWeekend 
                      ? (isDark ? Color(0xFFFF6B6B) : Colors.red)
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );
          },
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(events, isDark),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        headerVisible: false,
        daysOfWeekHeight: 40,
      ),
    );
  }

  Widget _buildEventsMarker(List events, bool isDark) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF3A3A3A) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: events.take(3).map((event) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: (event as Event).color.withOpacity(isDark ? 0.8 : 1.0),
                radius: 2,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventList(bool isDark) {
    final events = _events[_selectedDay] ?? [];
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'උත්සව',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white.withOpacity(0.95) : Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 48,
                          color: isDark
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'මෙම දිනයේ කිසිදු උත්සවයක් නොමැත',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.white.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index] as Event;
                      return Card(
                        elevation: isDark ? 2 : 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isDark
                            ? Color(0xFF2A2A2A)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: event.color.withOpacity(isDark ? 0.15 : 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.celebration,
                              color: event.color.withOpacity(isDark ? 0.9 : 1.0),
                            ),
                          ),
                          title: Text(
                            event.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.95) 
                                  : Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.6) 
                                  : Colors.black54,
                            ),
                            onPressed: () => _showEventDetails(event),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? Color(0xFF2A2A2A)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          event.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark 
                ? Colors.white.withOpacity(0.95) 
                : Colors.black87,
          ),
        ),
        content: Text(
          'උත්සව විස්තර මෙතැන දැක්විය හැක.',
          style: TextStyle(
            color: isDark 
                ? Colors.white.withOpacity(0.7) 
                : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'වසන්න',
              style: TextStyle(
                color: isDark 
                    ? Color(0xFF3498DB) 
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}