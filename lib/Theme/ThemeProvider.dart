import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _selectedColor = Colors.blue;
  String _selectedFont = 'Roboto';
  String _layoutOption = 'Cách sắp xếp 1';

  // Getter để lấy các giá trị tùy chỉnh
  Color get selectedColor => _selectedColor;
  String get selectedFont => _selectedFont;
  String get layoutOption => _layoutOption;

  // Setter để thay đổi và cập nhật giao diện
  void updateColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void updateFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }

  void updateLayout(String layout) {
    _layoutOption = layout;
    notifyListeners();
  }

  // Cấu hình ThemeData để thay đổi màu sắc và font chữ toàn bộ ứng dụng
  ThemeData getThemeData() {
    return ThemeData(
      primaryColor: _selectedColor,
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontFamily: _selectedFont),
      ),
    );
  }
}
