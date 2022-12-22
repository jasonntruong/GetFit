import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({Key? key, required this.weekSchedule})
      : super(key: key);
  final Map<String, Map<String, String>> weekSchedule;
  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
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
          widget.weekSchedule[day]?[type] = _hour.toString() +
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
      children: widget.weekSchedule.keys
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
                    time: widget.weekSchedule[day]?["Start"] ?? "11:30 AM",
                    day: day,
                    updateSchedule: (time) =>
                        updateSchedule(day, "Start", time),
                  ),
                  TimeLabel(
                    title: "End:",
                    time: widget.weekSchedule[day]?["End"] ?? "11:30 AM",
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
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.white,
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
      child: SizedBox(
        width: 75,
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
                        onDateTimeChanged: (time) =>
                            widget.updateSchedule(time),
                        backgroundColor: CupertinoColors.white,
                        mode: CupertinoDatePickerMode.time,
                      ),
                    ),
                child: Text(widget.time),
                padding: const EdgeInsets.all(0)),
          ],
        ),
      ),
    );
  }
}

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);
  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  bool _isLoaded = false;

  final Map<String, Map<String, String>> _defaultWeekSchedule = {
    "Sunday": {"Start": "11:30 AM", "End": "1:30 PM"},
    "Monday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Tuesday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Wednesday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Thursday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Friday": {"Start": "9:30 AM", "End": "12:30 PM"},
    "Saturday": {"Start": "9:30 AM", "End": "12:30 PM"},
  };

  Map<String, Map<String, String>> _weekSchedule = {};

  void onLoad() async {
    if (_weekSchedule.keys.isEmpty) {
      Map<String, Map<String, String>> prefSchedule = await getWeekSchedule();
      setState(() {
        _weekSchedule = prefSchedule;
        _isLoaded = true;
      });
    }
  }

  Future<Map<String, Map<String, String>>> getWeekSchedule() async {
    String? schedule;
    await SharedPreferences.getInstance().then((prefs) => {
          schedule = prefs.getString('schedule') as String,
          if (schedule == null)
            prefs.setString('schedule', jsonEncode(_defaultWeekSchedule))
        });
    if (schedule == null) return _defaultWeekSchedule;
    return formatWeekScheduleFromSharedPreferences(
        await jsonDecode(schedule as String));
  }

  Map<String, Map<String, String>> formatWeekScheduleFromSharedPreferences(
      sharedPrefsJSON) {
    final Map<String, Map<String, String>> weekSchedule =
        Map<String, Map<String, String>>.from(_defaultWeekSchedule);
    weekSchedule.keys.forEach((key) => {
          weekSchedule[key]?["Start"] = sharedPrefsJSON[key]?["Start"],
          weekSchedule[key]?["End"] = sharedPrefsJSON[key]?["End"],
        });
    return weekSchedule;
  }

  saveWeekSchedule() async {
    await SharedPreferences.getInstance().then(
      (prefs) => {
        prefs.setString('schedule', jsonEncode(_weekSchedule)),
      },
    );
  }

  discardWeekSchedule() async {
    Map<String, Map<String, String>> prefSchedule = await getWeekSchedule();
    setState(() {
      _weekSchedule = prefSchedule;
    });
  }

  @override
  Widget build(BuildContext context) {
    onLoad();
    return _isLoaded
        ? Column(
            children: [
              WeeklySchedule(
                weekSchedule: _weekSchedule,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                      onPressed: discardWeekSchedule,
                      child: const Text("Discard Changes")),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.fromLTRB(40, 18, 40, 18),
                    onPressed: saveWeekSchedule,
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
