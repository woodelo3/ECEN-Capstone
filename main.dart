import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'google_sheets.dart';

import 'all_zones_page.dart';
import 'wateringschedule_page.dart';
import 'line_graphs.dart';

//void main() => runApp(MyApp());
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await googleSheet.init();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static const String _title = 'SMART Irrigation Controller';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text(_title)),
        body: const AllPages(),
      ),
    );
  }
}

class AllPages extends StatelessWidget {
  const AllPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: <Widget>[
        Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                AllZones_PageHeader(),
                MySlider("Front Yard", 2, 11),
                MySlider("Front Yard - Driveway Side", 2, 12),
                MySlider("Backyard 1", 2, 13),
                MySlider("Backyard 2", 2, 14),
                MySlider("Backyard 3", 2, 15),
                MySlider("Alley - Front Door Side", 2, 16),
                MySlider("Alley - Driveway Side", 2, 17),
                MySlider("Zone 08", 2, 18),
                MySlider("Zone 09", 2, 19),
                MySlider("Zone 10", 2, 20)
              ])),
        ),
        Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Watering_PageHeader(),
                timeInput(),
                CheckBox("Sunday", 2, 2),
                CheckBox("Monday", 2, 3),
                CheckBox("Tuesday", 2, 4),
                CheckBox("Wednesday", 2, 5),
                CheckBox("Thursday", 2, 6),
                CheckBox("Friday", 2, 7),
                CheckBox("Saturday", 2, 8),
              ]),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  LineGraphs(),
                ]),
          ),
        )
      ],
    );
  }
}
