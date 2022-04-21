import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'google_sheets.dart';
import 'package:mysql1/mysql1.dart';

import 'package:flutter/cupertino.dart';

List<TempData> firstSet = <TempData>[];

List<HumidData> humidPoints = <HumidData>[];

List<MoistureData> moistPoints = <MoistureData>[];

class LineGraphs extends StatefulWidget {
  @override
  State<LineGraphs> createState() => _Graphs();
}

class _Graphs extends State<LineGraphs> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          SfCartesianChart(
              title: ChartTitle(
                text: 'Temperature',
                textStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              // Enables the legend
              legend: Legend(isVisible: false),
              // Initialize category axis
              primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
              primaryYAxis: CategoryAxis(title: AxisTitle(text: '°F')),
              backgroundColor: Colors.white,
              series: <ChartSeries>[
                // Initialize line series
                LineSeries<TempData, String>(
                  dataSource: firstSet,
                  xValueMapper: (TempData sales, _) => sales.year,
                  yValueMapper: (TempData sales, _) => sales.sales,
                )
              ]),
          SfCartesianChart(
              title: ChartTitle(
                text: 'Humidity',
                textStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              // Enables the legend
              legend: Legend(isVisible: false),
              // Initialize category axis
              primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
              primaryYAxis: CategoryAxis(title: AxisTitle(text: '%')),
              backgroundColor: Colors.white,
              series: <ChartSeries>[
                // Initialize line series
                LineSeries<HumidData, String>(
                  dataSource: humidPoints,
                  xValueMapper: (HumidData value, _) => value.date,
                  yValueMapper: (HumidData value, _) => value.value,
                )
              ]),
          SfCartesianChart(
              title: ChartTitle(
                text: 'Soil Moisture',
                textStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              // Enables the legend
              legend: Legend(isVisible: false),
              // Initialize category axis
              primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
              primaryYAxis: CategoryAxis(title: AxisTitle(text: '%')),
              backgroundColor: Colors.white,
              series: <ChartSeries>[
                // Initialize line series
                LineSeries<MoistureData, String>(
                  dataSource: moistPoints,
                  xValueMapper: (MoistureData value, _) => value.date,
                  yValueMapper: (MoistureData value, _) => value.value,
                )
              ]),
          FloatingActionButton(
            onPressed: () => setState(() {
              firstSet = <TempData>[];
              firstSet = _getfirstSet();
              humidPoints = <HumidData>[];
              humidPoints = _getHumidData();
              moistPoints = <MoistureData>[];
              moistPoints = _getMoistData();
            }),
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ]));
  }

  void foo(int column) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: "sql5.freemysqlhosting.net",
        user: 'sql5486851',
        db: 'sql5486851',
        password: 'AV2VWZlUk5'));

    String current_day = '';
    String yValue = '';
    String time = '';
    String newDay = '';
    var results = await conn.query('select * from SensorData');
    int i = 0;

    for (var row in results) {
      current_day = row[0].substring(5, 10);
      if (current_day == newDay) {
        current_day = '';
      } else {
        newDay = current_day;
      }
      time = '${row[1]}'.substring(0, 5);
      switch (column) {
        case 2:
          yValue = '${row[column]}';
          print(yValue);
          firstSet
              .add(TempData((current_day + ' ' + time), double.parse(yValue)));
          break;
        case 3:
          yValue = '${row[column]}';
          humidPoints
              .add(HumidData((current_day + ' ' + time), double.parse(yValue)));
          break;
        case 4:
          yValue = '${row[column]}';
          moistPoints.add(
              MoistureData((current_day + ' ' + time), double.parse(yValue)));
          break;
        default:
          break;
      }

      i += 1;
      if (i > 200) {
        break;
      }
    }
    await conn.close();
  }

  List<TempData> _getfirstSet() {
    foo(2);
    return firstSet;
  }

  List<HumidData> _getHumidData() {
    foo(3);
    return humidPoints;
  }

  List<MoistureData> _getMoistData() {
    foo(4);
    return moistPoints;
  }
}

class TempData {
  TempData(this.year, this.sales);
  final String year;
  final double? sales;
}

class HumidData {
  HumidData(this.date, this.value);
  final String date;
  final double? value;
}

class MoistureData {
  MoistureData(this.date, this.value);
  final String date;
  final double? value;
}
