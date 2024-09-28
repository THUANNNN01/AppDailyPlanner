import 'package:flutter/material.dart';
import 'CustomizationScreen.dart';
import 'NotificationSettingsScreen.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  SettingsScreen({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chế độ sáng/tối
            SwitchListTile(
              title: Text('Chế độ tối'),
              value: isDarkMode,
              onChanged: (bool value) {
                onDarkModeChanged(value); // Thông báo thay đổi trạng thái chế độ tối
              },
            ),
            Divider(),

            // Tùy chỉnh giao diện
            ListTile(
              title: Text('Tùy chỉnh giao diện'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomizationScreen()),
                );
              },
            ),
            Divider(),

            // Thông báo nhiệm vụ
            ListTile(
              title: Text('Cài đặt thông báo nhiệm vụ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationSettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
