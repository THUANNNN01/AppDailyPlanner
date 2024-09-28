import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TaskDetailScreen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  /// Lấy danh sách nhiệm vụ từ Firestore và lưu trữ chúng vào _events
  Future<void> _fetchEvents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();

    Map<DateTime, List<Map<String, dynamic>>> events = {};

    for (var doc in snapshot.docs) {
      Map<String, dynamic> taskData = doc.data() as Map<String, dynamic>;
      DateTime taskDate = DateTime.parse(taskData['date']); // Chuyển đổi string thành DateTime

      if (events[taskDate] == null) {
        events[taskDate] = [];
      }
      events[taskDate]?.add(taskData);
    }

    setState(() {
      _events = events;
    });
  }

  /// Lấy danh sách nhiệm vụ cho ngày cụ thể
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch công việc'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay, // Tải danh sách nhiệm vụ cho mỗi ngày
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Colors.red, // Màu dấu hiệu cho ngày có nhiệm vụ
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _selectedDay != null
                ? ListView.builder(
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                var task = _getEventsForDay(_selectedDay)[index];
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['description'] ?? 'Không có mô tả'),
                  onTap: () {
                    // Chuyển đến màn hình chi tiết công việc
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(taskId: task['id']),
                      ),
                    );
                  },
                );
              },
            )
                : Center(
              child: Text('Chọn ngày để xem công việc'),
            ),
          ),
        ],
      ),
    );
  }
}
