import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySlider extends StatefulWidget {
  String zoneName;
  int _col;
  int _row;
  double _currentSliderValue = 0;

  MySlider(this.zoneName, this._col, this._row);
  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<MySlider> {
  double sliderBuffer = 0;

  void newZoneValue() {
    setState(() {
      widget._currentSliderValue = sliderBuffer;
    });
  }

  Future updateTable() async {
    // googleSheet.changeZoneTimer(
    //     widget._col, widget._row, widget._currentSliderValue);

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: "sql5.freemysqlhosting.net",
        user: 'sql5486851',
        db: 'sql5486851',
        password: 'AV2VWZlUk5'));
    String zone = "0";

    switch (widget.zoneName) {
      case "Front Yard":
        {
          zone = "1";
        }
        break;
      case "Front Yard - Driveway Side":
        {
          zone = "2";
        }
        break;
      case "Backyard 1":
        {
          zone = "3";
        }
        break;
      case "Backyard 2":
        {
          zone = "4";
        }
        break;
      case "Backyard 3":
        {
          zone = "5";
        }
        break;
      case "Alley - Front Door Side":
        {
          zone = "6";
        }
        break;
      case "Alley - Driveway Side":
        {
          zone = "7";
        }
        break;
      case "Zone 08":
        {
          zone = "8";
        }
        break;
      case "Zone 09":
        {
          zone = "9";
        }
        break;
      case "Zone 10":
        {
          zone = "10";
        }
        break;

      default:
        {
          zone = "0";
        }
        break;
    }

    await conn.query('update ZoneTimers set Timer=? where Zone=?',
        [widget._currentSliderValue, zone]);

    await conn.close();

    print(widget._currentSliderValue);
    print(widget.zoneName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(""),
              Text(
                widget.zoneName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontFamily: "Times New Roman",
                    fontWeight: FontWeight.w800),
              ),
              Text(" (" + widget._currentSliderValue.toString() + " min.)"),
            ],
          ),
          Slider(
            value: widget._currentSliderValue,
            min: 0,
            max: 15,
            divisions: 15,
            label: widget._currentSliderValue.round().toString(),
            onChanged: (double value) {
              sliderBuffer = value;
              newZoneValue();
            },
            onChangeEnd: (double value) {
              updateTable();
              print(widget.zoneName +
                  " timer = " +
                  widget._currentSliderValue.toString() +
                  "min");
            },
          )
        ]);
  }
}

class AllZones_PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(""),
          const Text(
            "Zone Control",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.blue,
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w800),
          ),
          const Text(""),
        ]);
  }
}
