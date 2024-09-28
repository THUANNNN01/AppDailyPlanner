import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Khởi tạo múi giờ
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); // Khởi tạo plugin

    // Cài đặt cho thông báo
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher'); // Đảm bảo icon tồn tại
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    // Khởi tạo plugin với settings và tham số onSelectNotification
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        if (notificationResponse.payload != null) {
          print('Thông báo được nhấn: ${notificationResponse.payload}');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Thông báo'),
              content: Text('Bạn đã nhấn vào thông báo: ${notificationResponse.payload}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Đóng'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void scheduleNotification(DateTime dateTime) async {
    // Chuyển đổi DateTime thành TZDateTime
    tz.TZDateTime scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Nhắc nhở công việc', // Tiêu đề thông báo
      'Đã đến giờ thực hiện công việc.', // Nội dung thông báo
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // ID của kênh thông báo
          'your_channel_name', // Tên của kênh
          channelDescription: 'your_channel_description', // Mô tả kênh
          importance: Importance.max, // Độ quan trọng
          priority: Priority.high, // Ưu tiên cao
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'Thông điệp từ thông báo', // Payload có thể tùy chỉnh
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt thông báo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Gọi hàm lên lịch thông báo
            scheduleNotification(DateTime.now().add(Duration(seconds: 10))); // Thí dụ: thông báo sau 10 giây
          },
          child: Text('Lên lịch thông báo'),
        ),
      ),
    );
  }
}
