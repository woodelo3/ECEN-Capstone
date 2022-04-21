import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';

class _googleSheet extends StatefulWidget {
  @override
  State<_googleSheet> createState() => googleSheet();
}

class googleSheet extends State<_googleSheet> {
  static Future init() async {
    final daysList = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      'Thursday',
      'Friday',
      'Saturday'
    ];

    // Zone Names
    final zoneNamesList = ["1", "2", "3", "4", "5", "6", "7", "08", "9", "10"];

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: "sql5.freemysqlhosting.net",
        user: 'sql5486851',
        db: 'sql5486851',
        password: 'AV2VWZlUk5'));

    for (var x in daysList) {
      await conn
          .query('update UserWateringDays set TF=? where Day=?', ['0', x]);
    }
    for (var x in zoneNamesList) {
      await conn.query('update ZoneTimers set Timer=? where Zone=?', ['0', x]);
    }
    for (var x in zoneNamesList) {
      await conn.query(
          'update WateringTime set wateringTime=? where row=?', ['00:00', '1']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
