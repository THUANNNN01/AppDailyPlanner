import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskId; // ID của công việc (nếu chỉnh sửa)
  final Map<String, dynamic>? existingData; // Dữ liệu hiện có của công việc

  AddTaskScreen({this.taskId, this.existingData});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _moderatorController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 11, minute: 0);
  String _selectedStatus = "Tạo mới";
  String _selectedDayOfWeek = "Thứ 2";

  List<String> _taskStatuses = ["Tạo mới", "Thực hiện", "Thành công", "Kết thúc"];
  List<String> _daysOfWeek = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ Nhật"];

  @override
  void initState() {
    super.initState();

    // Nếu có dữ liệu công việc thì điền dữ liệu sẵn có vào các trường
    if (widget.existingData != null) {
      _titleController.text = widget.existingData!['title'];
      _descriptionController.text = widget.existingData!['description'];
      _locationController.text = widget.existingData!['location'];
      _moderatorController.text = widget.existingData!['moderator'];
      _noteController.text = widget.existingData!['note'];
      _selectedDate = DateTime.parse(widget.existingData!['date']);
      _startTime = TimeOfDay.fromDateTime(DateTime.parse(widget.existingData!['startTime']));
      _endTime = TimeOfDay.fromDateTime(DateTime.parse(widget.existingData!['endTime']));
      _selectedStatus = widget.existingData!['status'];
      _selectedDayOfWeek = widget.existingData!['dayOfWeek'] ?? "Thứ 2";
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      // Dữ liệu công việc mới
      Map<String, dynamic> taskData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _selectedDate.toString(),
        'startTime': DateTime(_startTime.hour, _startTime.minute).toString(),
        'endTime': DateTime( _endTime.hour, _endTime.minute).toString(),
        'location': _locationController.text,
        'moderator': _moderatorController.text,
        'note': _noteController.text,
        'status': _selectedStatus,
        'dayOfWeek': _selectedDayOfWeek,
      };

      // Nếu có ID (tức là đang chỉnh sửa), update công việc
      if (widget.taskId != null) {
        await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update(taskData);
      } else {
        // Nếu không có ID (tức là thêm mới), tạo công việc mới
        await FirebaseFirestore.instance.collection('tasks').add(taskData);
      }

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Công việc đã được lưu thành công!')),
      );


      // Quay lại màn hình danh sách công việc
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName)); // Đảm bảo đã trở về màn hình danh sách

    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Thêm công việc mới' : 'Chỉnh sửa công việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Nội dung công việc'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung công việc';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Chi tiết công việc'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chi tiết công việc';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Địa điểm'),
              ),
              TextFormField(
                controller: _moderatorController,
                decoration: InputDecoration(labelText: 'Chủ trì'),
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Ghi chú'),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  "Ngày: ${_selectedDate.day.toString().padLeft(2, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.year}",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text("Thời gian bắt đầu: ${_startTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectStartTime(context),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text("Thời gian kết thúc: ${_endTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectEndTime(context),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: 'Trạng thái công việc'),
                items: _taskStatuses.map((String status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue as String;
                  });
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.taskId == null ? 'Thêm công việc' : 'Cập nhật công việc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
