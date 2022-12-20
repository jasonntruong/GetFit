import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({Key? key}) : super(key: key);
  @override
  State<WeeklySchedule> createState() => _WeekdlyScheduleState();
}

class _WeekdlyScheduleState extends State<WeeklySchedule> {
  final Map _weekSchedule = {
    "Sunday": {"Start": "11:30 AM", "End": "1:30 PM"},
    "Monday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Tuesday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Wednesday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Thursday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Friday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Saturday": {"Start": "9:30 AM", "End": "12:30 PM"},
  };

  void updateSchedule(day, type, DateTime time) {
    String _ending = "AM";
    int _hour = time.hour;
    if (_hour >= 12) {
      _ending = "PM";
      if (_hour > 12) _hour -= 12;
    } else if (_hour == 0) {
      _hour = 12;
    }
    setState(() => {
          _weekSchedule[day][type] = _hour.toString() +
              ":" +
              (time.minute < 10 ? "0" : "") +
              time.minute.toString() +
              " " +
              _ending
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _weekSchedule.keys
          .map(
            (day) => Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 36.0),
              child: Row(
                children: [
                  Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Color(0xff313131),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          day[0].toLowerCase(),
                          style: const TextStyle(fontSize: 32.0),
                        ),
                      ],
                    ),
                  ),
                  TimeLabel(
                    title: "Start:",
                    time: _weekSchedule[day]["Start"],
                    day: day,
                    updateSchedule: (time) =>
                        updateSchedule(day, "Start", time),
                  ),
                  TimeLabel(
                    title: "End:",
                    time: _weekSchedule[day]["End"],
                    day: day,
                    updateSchedule: (time) => updateSchedule(day, "End", time),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class TimeLabel extends StatefulWidget {
  const TimeLabel(
      {Key? key,
      required this.title,
      required this.time,
      required this.day,
      required this.updateSchedule})
      : super(key: key);
  final String title;
  final String time;
  final void Function(DateTime) updateSchedule;

  final String day;

  @override
  State<TimeLabel> createState() => _TimeLabelState();
}

class _TimeLabelState extends State<TimeLabel> {
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          CupertinoButton(
              alignment: Alignment.centerLeft,
              onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      onDateTimeChanged: (time) => widget.updateSchedule(time),
                      backgroundColor: Colors.white,
                      mode: CupertinoDatePickerMode.time,
                    ),
                  ),
              child: Text(widget.time),
              padding: const EdgeInsets.all(0)),
        ],
      ),
    );
  }
}
