import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Bill {
  final int id;
  final double consumption;
  final int NormalConsp;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;

  Bill({
    required this.id,
    required this.consumption,
    required this.NormalConsp,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      consumption: json['consumption'].toDouble(),
      NormalConsp: json['NormalConsp'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      userId: json['userId'],
    );
  }
}

class MyBarGraph extends StatelessWidget {
  final List<Bill> bills;
  final double threshold = 27;

  const MyBarGraph({
    Key? key,
    required this.bills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < bills.length; i++) {
      double value = bills[i].consumption;
      double diff = value - threshold;
      double excess = diff > 0 ? diff : 0;
      double base = value > threshold ? threshold : value;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: (excess + base),
              colors: [Color.fromRGBO(191, 28, 28, 1)],
              width: 30,
              borderRadius: BorderRadius.circular(0),
              rodStackItems: [
                BarChartRodStackItem(0, base, Color.fromRGBO(19, 47, 202, 1)),
              ],
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 16, // Adjust the top value as needed
          bottom: 0,
          child: Container(
            margin: EdgeInsets.only(bottom: 50), // Add spacing here
            child: BarChart(
              BarChartData(
                maxY: 60,
                minY: 0,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: SideTitles(
                    showTitles: false,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Q1';
                        case 1:
                          return 'Q2';
                        case 2:
                          return 'Q3';
                        case 3:
                          return 'Q4';
                        default:
                          return '';
                      }
                    },
                    margin: 10,
                    reservedSize: 30,
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    interval: 10,
                    margin: 10,
                    reservedSize: 30,
                    getTitles: (value) {
                      if (value % 10 == 0) {
                        return '${value.toInt()} m³';
                      }
                      return '';
                    },
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.black, width: 1.5),
                    left: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ),
        Positioned(
          left: 60,
          top: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 16,
                    color: Color.fromRGBO(19, 47, 202, 1),
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Normal Consumption',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 16,
                    color: Color.fromRGBO(191, 28, 28, 1),
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Over Consumption',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}