import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_planner_app/Theme/ThemeProvider.dart';

class CustomizationScreen extends StatefulWidget {
  @override
  _CustomizationScreenState createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  // Danh sách các màu sắc và font chữ như đã tạo
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
  ];

  final List<String> _fontOptions = [
    'Roboto',
    'Open Sans',
    'Lobster',
    'Montserrat',
  ];

  final List<String> _layoutOptions = [
    'Cách sắp xếp 1',
    'Cách sắp xếp 2',
    'Cách sắp xếp 3',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tùy chỉnh giao diện'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tùy chọn màu sắc
            Text(
              'Chọn màu sắc:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    themeProvider.updateColor(color); // Cập nhật màu sắc
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      border: themeProvider.selectedColor == color
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            Divider(height: 40),

            // Tùy chọn font chữ
            Text(
              'Chọn font chữ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: themeProvider.selectedFont,
              onChanged: (String? newFont) {
                themeProvider.updateFont(newFont!); // Cập nhật font chữ
              },
              items: _fontOptions.map<DropdownMenuItem<String>>((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
            ),
            Divider(height: 40),

            // Tùy chọn cách sắp xếp
            Text(
              'Chọn cách sắp xếp:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: _layoutOptions.map((layout) {
                return RadioListTile<String>(
                  title: Text(layout),
                  value: layout,
                  groupValue: themeProvider.layoutOption,
                  onChanged: (String? value) {
                    themeProvider.updateLayout(value!); // Cập nhật cách sắp xếp
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Nút lưu (thực ra đã lưu ngay khi chọn)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Đã lưu các thay đổi!'),
                  ));
                },
                child: Text('Lưu thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
