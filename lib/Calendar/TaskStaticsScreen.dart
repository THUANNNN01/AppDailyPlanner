import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Đảm bảo đã import fl_chart

class TaskStatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống Kê Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Biểu đồ công việc',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            MyPieChart(), // Sử dụng MyPieChart ở đây
          ],
        ),
      ),
    );
  }
}

// Đặt MyPieChart bên dưới TaskStatisticsScreen
class MyPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, color: Colors.blue, title: 'Hoàn thành', titleStyle: TextStyle(color: Colors.white)),
          PieChartSectionData(value: 60, color: Colors.red, title: 'Chưa hoàn thành', titleStyle: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
