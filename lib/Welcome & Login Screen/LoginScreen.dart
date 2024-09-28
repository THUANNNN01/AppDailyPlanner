import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Hàm đăng nhập
  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Giả sử bạn kiểm tra username và password đúng
    if (username.isNotEmpty && password.isNotEmpty) {
      // Lưu thông tin đăng nhập vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      // Điều hướng tới màn hình chính
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = "Vui lòng nhập thông tin đăng nhập hợp lệ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Thay đổi màu nền thành trắng
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 5), // Viền xám
                  borderRadius: BorderRadius.circular(90), // Bo góc
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90), // Bo góc cho hình ảnh
                  child: Image.asset(
                    'assets/images/logo.jpg', // Đường dẫn đến logo
                    height: 150, // Chiều cao logo
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'AccountID'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _login,
                child: Text('Đăng nhập'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10), // Thay đổi kích thước nút
                  textStyle: TextStyle(fontSize: 20), // Thay đổi kích thước chữ
                ),
              ),
              SizedBox(height: 50),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
