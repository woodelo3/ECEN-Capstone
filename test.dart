import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'dart:async';

void main() async {
  print("WE ARE IN HERE");
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sql5.freemysqlhosting.net',
      user: 'sql5480895',
      db: 'sql5480895',
      password: '8EV1csK5jJ'));

  var results = await conn.query('select * from Data');
  String current_day = '';
  String unique_day = '';
  int i = 0;
  String xValue = '';
  String yValue = '';
  String time = '';

  for (var row in results) {
    current_day = '${row[0]}'.substring(5, 10);
    xValue = '';

    if (current_day != unique_day) {
      unique_day = current_day;
      xValue = unique_day;
    }

    yValue = '${row[5]}'.substring(0, 5);
    time = '${row[1]}'.substring(0, 5);
    print(xValue + ' ' + time + ' --- ' + yValue);

    i += 1;
    if (i == 10) {
      exitCode;
    }
  }

  await conn.close();
}
