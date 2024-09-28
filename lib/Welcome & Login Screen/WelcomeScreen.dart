import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Container(height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
            Text(
              'Daily Planner',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Đăng nhập'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                foregroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
    ),
    );
  }
}