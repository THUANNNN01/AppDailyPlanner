import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  TaskDetailScreen({required this.taskId});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late DocumentSnapshot task;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).get();
    setState(() {
      task = doc;
    });
  }

  Future<void> _updateTask() async {
    await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
      'title': task['title'],
      'description': task['description'],
      'status': task['status'],
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết công việc'),
      ),
      body: task == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: task['title'],
              decoration: InputDecoration(labelText: 'Tiêu đề'),
              onChanged: (value) {
                task.reference.update({'title': value});
              },
            ),
            TextFormField(
              initialValue: task['description'],
              decoration: InputDecoration(labelText: 'Mô tả'),
              onChanged: (value) {
                task.reference.update({'description': value});
              },
            ),
            DropdownButtonFormField<String>(
              value: task['status'],
              items: ['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                task.reference.update({'status': value});
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Cập nhật công việc'),
            ),
          ],
        ),
      ),
    );
  }
}
