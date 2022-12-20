import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Weekday extends StatefulWidget {
  const Weekday({Key? key, required this.day}) : super(key: key);
  final String day;
  @override
  State<Weekday> createState() => _WeekdayState();
}

class _WeekdayState extends State<Weekday> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
              widget.day,
              style: const TextStyle(fontSize: 32.0),
            ),
          ],
        ),
      ),
      const TimeLabel(title: "Start:"),
      const TimeLabel(title: "End:"),
    ]);
  }
}

class TimeLabel extends StatelessWidget {
  const TimeLabel({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text("11:30 AM"),
        ],
      ),
    );
  }
}

class WeeklySchedule extends StatelessWidget {
  const WeeklySchedule({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> weekdays = ['s', 'm', 't', 'w', 't', 'f', 's'];

    return Column(
      children: weekdays
          .map(
            (day) => Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 36.0),
              child: Weekday(
                day: day,
              ),
            ),
          )
          .toList(),
    );
  }
}
