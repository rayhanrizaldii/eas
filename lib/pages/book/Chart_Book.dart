import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class ChartBook extends StatefulWidget {
  const ChartBook({super.key});

  @override
  State<ChartBook> createState() => _ChartBookState();
}

class _ChartBookState extends State<ChartBook> {
  List<Map<String, dynamic>> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://192.168.18.213:8080/eas/buku/chart.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        chartData = data.cast<Map<String, dynamic>>();
      });
    } else {
      print('Gagal mengambil data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('1462100047'),
        elevation: 0,
        backgroundColor: Color(0xff7FC7D9),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Chart Tabel Buku',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Expanded(
              child: Container(
                width: 300,
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 60,
                    sections: getSections(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getRandomColor(index),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${chartData[index]['jenis']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    List<PieChartSectionData> sections = [];

    for (int i = 0; i < chartData.length; i++) {
      sections.add(
        PieChartSectionData(
          color: getRandomColor(i),
          value: chartData[i]['jumlah'].toDouble(),
          radius: 30,
          title: '${chartData[i]['jumlah']}',
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  Color getRandomColor(int seed) {
    return Color.fromRGBO(
      (255 * (seed * 0.2 + 0.9)).toInt(),
      (255 * (seed * 0.3 + 0.3)).toInt(),
      (255 * (seed * 0.4 + 0.4)).toInt(),
      1,
    );
  }
}
