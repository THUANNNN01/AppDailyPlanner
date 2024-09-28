import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Calendar/CalendarScreen.dart';
import 'Task/TaskList.dart';
import 'Calendar/TaskStaticsScreen.dart';
import 'Calendar/SettingsScreen.dart'; // Màn hình cài đặt
import 'Welcome & Login Screen/WelcomeScreen.dart';
import 'Welcome & Login Screen/LoginScreen.dart';
import 'Welcome & Login Screen/SignupScreen.dart';
import 'Task/AddNewTask.dart';
import 'Theme/ThemeProvider.dart'; // Đảm bảo đã nhập ThemeProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo khởi tạo trước khi runApp
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Khởi tạo ThemeProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Planner',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: WelcomeScreen(), // Hiển thị màn hình Welcome trước tiên
      routes: {
        '/home': (context) => TaskListScreen(
          isDarkMode: _isDarkMode, // Truyền tham số isDarkMode
          onDarkModeChanged: _toggleDarkMode, // Truyền tham số onDarkModeChanged
        ), // Điều hướng tới TaskListScreen sau khi đăng nhập
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/addTask': (context) => AddTaskScreen(),
        '/statistics': (context) => TaskStatisticsScreen(),
      },
    );
  }
}

// TaskListScreen để điều hướng đến nội dung
class TaskListScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  TaskListScreen({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Công việc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Thống Kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        backgroundColor: Colors.lightBlueAccent,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  List<Widget> get _screens => [
    TaskListScreenContent(),
    CalendarScreen(),
    TaskStatisticsScreen(),
    SettingsScreen(
      isDarkMode: widget.isDarkMode, // Truyền trạng thái chế độ tối
      onDarkModeChanged: widget.onDarkModeChanged, // Truyền hàm thay đổi chế độ tối
    ),
  ];
}

// Màn hình danh sách công việc
class TaskListScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Công việc'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()), // Điều hướng đến AddTaskScreen
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tasks.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((task) {
              DateTime startTime = DateTime.parse(task['startTime']);
              DateTime endTime = DateTime.parse(task['endTime']);
              Duration workingDuration = endTime.difference(startTime);

              int workingHours = workingDuration.inHours;
              int workingMinutes = workingDuration.inMinutes % 60;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(task['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ngày: ${task['date']}", style: TextStyle(fontSize: 14)),
                      Text("Thời gian làm việc: $workingHours giờ $workingMinutes phút", style: TextStyle(fontSize: 14)),
                      Text("Địa điểm: ${task['location']}", style: TextStyle(fontSize: 14)),
                      Text("Chủ trì: ${task['moderator']}", style: TextStyle(fontSize: 14)),
                      Text("Ghi chú: ${task['note']}", style: TextStyle(fontSize: 14)),
                      Text("Trạng thái: ${task['status']}", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Chuyển đến màn hình chỉnh sửa với dữ liệu công việc hiện tại
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(
                                taskId: task.id, // Truyền ID công việc để chỉnh sửa
                                existingData: task.data() as Map<String, dynamic>, // Truyền dữ liệu công việc
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Xác nhận xóa công việc
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Xác nhận"),
                              content: Text("Bạn có chắc chắn muốn xóa công việc này?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    tasks.doc(task.id).delete(); // Xóa công việc
                                    Navigator.pop(context);
                                  },
                                  child: Text("Xóa"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
