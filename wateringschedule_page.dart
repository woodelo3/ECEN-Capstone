import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';

class CheckBox extends StatefulWidget {
  String dayName;
  int _col;
  int _row;
  bool isChecked = false;
  CheckBox(this.dayName, this._col, this._row);

  @override
  State<CheckBox> createState() => _CheckBoxState(dayName);
}

class _CheckBoxState extends State<CheckBox> {
  String dayName;
  _CheckBoxState(this.dayName);

  Future updateTable() async {
    // googleSheet.changeZoneTimer(
    //     widget._col, widget._row, widget._currentSliderValue);

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: "sql5.freemysqlhosting.net",
        user: 'sql5486851',
        db: 'sql5486851',
        password: 'AV2VWZlUk5'));

    await conn.query('update UserWateringDays set TF=? where Day=?',
        [widget.isChecked, widget.dayName]);

    await conn.close();

    print(widget.isChecked);
    print(widget.dayName);
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return Colors.blue;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(""),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: widget.isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isChecked = value!;
                    print("Water on " +
                        widget.dayName +
                        ": " +
                        widget.isChecked.toString());
                  });
                  updateTable();
                  // googleSheet.changeWaterDay(
                  //     widget._col, widget._row, widget.isChecked);
                },
              ),
              Expanded(
                child: Text(
                  dayName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.blue,
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.w500),
                ),
              ),
            ])
      ],
    );
  }
}

class timeInput extends StatefulWidget {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  @override
  State<timeInput> createState() => _timeInputState();
}

class _timeInputState extends State<timeInput> {
  Future updateWateringTime(String selectedTime) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: "sql5.freemysqlhosting.net",
        user: 'sql5486851',
        db: 'sql5486851',
        password: 'AV2VWZlUk5'));

    await conn.query('update WateringTime set wateringTime=? where row=?',
        [selectedTime, '1']);

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            _selectTime(context);
            updateWateringTime(
                "${widget.selectedTime.hour}:${widget.selectedTime.minute}");
          },
          child: Text("Select Time"),
        ),
        Text("${widget.selectedTime.hour}:${widget.selectedTime.minute}"),
      ],
    );
  }

  _selectTime(BuildContext context) async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
      confirmText: "CONFIRM",
      cancelText: "CANCEL",
      helpText: " WATERING TIME",
    );

    if (timeOfDay != null && timeOfDay != widget.selectedTime) {
      setState(() {
        widget.selectedTime = timeOfDay;
      });
    }

    print("New Watering Time: " + widget.selectedTime.toString());

    updateWateringTime(widget.selectedTime.toString().substring(10, 15));
  }
}

class Watering_PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(""),
          const Text(
            "Watering Schedule",
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
