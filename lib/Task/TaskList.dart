import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddNewTask.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder(
        stream: tasks.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
