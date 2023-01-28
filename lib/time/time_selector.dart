import 'package:flutter/cupertino.dart';
import 'package:get_fit/time/time.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector(
      {Key? key,
      required this.title,
      required this.time,
      required this.day,
      required this.disabled,
      required this.updateSchedule})
      : super(key: key);
  final String title;
  final String time;
  final bool disabled;
  final void Function(DateTime) updateSchedule;

  final String day;

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  /// Gets initial time for time selector modal
  DateTime getInitTime() {
    var parsedTime = parseTime(widget.time);
    String hour = parsedTime["hour"].toString();
    hour = hour.length == 1 ? "0" + hour : hour;
    String minute = parsedTime["minute"].toString();
    minute = minute.length == 1 ? "0" + minute : minute;
    // 2023-02-02 can be anything since we just need time
    return DateTime.parse("2023-02-02 $hour:$minute");
  }

  // Shows modal that displays child
  void _showModal(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 10),
        color: CupertinoColors.lightBackgroundGray,
        child: Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.darkBackgroundGray,
          child: SafeArea(
            top: false,
            child: child,
          ),
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
                onPressed: () => {
                      if (!widget.disabled)
                        {
                          /// Shows modal for time selector
                          _showModal(
                            CupertinoDatePicker(
                              onDateTimeChanged: (time) =>
                                  widget.updateSchedule(time),
                              backgroundColor:
                                  CupertinoColors.darkBackgroundGray,
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: getInitTime(),
                            ),
                          ),
                        },
                    },
                child: Text(widget.time),
                padding: const EdgeInsets.all(0)),
          ],
        ),
      ),
    );
  }
}
