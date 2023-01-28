/// Weekly schedule widget

import 'package:flutter/cupertino.dart';

import '../time/time_selector.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({Key? key, required this.weekSchedule})
      : super(key: key);
  final Map<String, Map<String, String>> weekSchedule;
  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  /// Updates weekly schedule object
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

  /// Toggles rest day
  void toggleRest(String day) {
    String rest = widget.weekSchedule[day]!["rest"]!;

    setState(() => {
          rest == "F"
              ? widget.weekSchedule[day]!["rest"] = "T"
              : widget.weekSchedule[day]!["rest"] = "F"
        });
  }

  /// Checks if day is a rest day
  bool isRest(String day) {
    return widget.weekSchedule[day]!["rest"]! == "T";
  }

  /// Gets scheduled time for that day's gym start or end time
  String getScheduledTime(day, type) {
    if (widget.weekSchedule[day]?["rest"] == "T") {
      return "REST";
    }
    return widget.weekSchedule[day]?[type] ?? "11:30 AM";
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
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Container(
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
                    onPressed: () => toggleRest(day),
                  ),
                  TimeSelector(
                    title: "Start:",
                    time: getScheduledTime(day, "Start"),
                    day: day,
                    disabled: isRest(day),
                    updateSchedule: (time) =>
                        updateSchedule(day, "Start", time),
                  ),
                  TimeSelector(
                    title: "End:",
                    time: getScheduledTime(day, "End"),
                    day: day,
                    disabled: isRest(day),
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
