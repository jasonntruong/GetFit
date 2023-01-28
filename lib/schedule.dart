/// Schedule tab widget

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_fit/helper/local_storage.dart';
import 'package:get_fit/alerts/notification.dart';
import 'package:get_fit/schedule/weekly_schedule.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key, required this.notificationController})
      : super(key: key);

  // notificationController to trigger notifications
  final NotificationController? notificationController;
  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  bool _isLoaded = false;

  final Map<String, Map<String, String>> _defaultWeekSchedule = {
    "Sunday": {"Start": "11:30 AM", "End": "1:30 PM", "rest": "F"},
    "Monday": {"Start": "9:30 AM", "End": "12:30 PM", "rest": "F"},
    "Tuesday": {"Start": "9:30 AM", "End": "12:30 PM", "rest": "F"},
    "Wednesday": {"Start": "9:30 AM", "End": "12:30 PM", "rest": "F"},
    "Thursday": {"Start": "9:30 AM", "End": "12:30 PM", "rest": "F"},
    "Friday": {"Start": "9:30 AM", "End": "12:30 PM", "rest": "F"},
    "Saturday": {"Start": "9:30 AM", "End": "12:30 PM", "rest": "F"},
  };

  Map<String, Map<String, String>> _weekSchedule = {};

  /// Runs when widget loads
  void onLoad() async {
    if (_weekSchedule.keys.isEmpty) {
      // Gets week schedule from storage
      Map<String, Map<String, String>> prefSchedule = await getWeekSchedule();
      setState(() {
        _weekSchedule = prefSchedule;
        _isLoaded = true;
      });
    }
  }

  /// Get week schedule from storage
  Future<Map<String, Map<String, String>>> getWeekSchedule() async {
    String? schedule = await getFromStorage('schedule');
    if (schedule == null) {
      await saveToStorage('schedule', jsonEncode(_defaultWeekSchedule));
      return _defaultWeekSchedule;
    }
    return copyWeekScheduleFromStorage(await jsonDecode(schedule));
  }

  /// Copies the week schedule from storage into weekSchedule
  Map<String, Map<String, String>> copyWeekScheduleFromStorage(
      storageSchedule) {
    final Map<String, Map<String, String>> weekSchedule =
        Map<String, Map<String, String>>.from(_defaultWeekSchedule);
    weekSchedule.keys.forEach((key) => {
          weekSchedule[key]?["Start"] = storageSchedule[key]?["Start"],
          weekSchedule[key]?["End"] = storageSchedule[key]?["End"],
        });
    return weekSchedule;
  }

  /// Saves schedule changes
  saveWeekSchedule() async {
    bool successfulSaveNotifications = await widget.notificationController!
        .scheduleWeekNotifications(_weekSchedule);
    if (successfulSaveNotifications) {
      await saveToStorage('schedule', jsonEncode(_weekSchedule));
      await saveLastUpdated();
    }
  }

  /// Discards changes to week schedule
  discardChangesToSchedule() async {
    Map<String, Map<String, String>> prefSchedule = await getWeekSchedule();
    setState(() {
      _weekSchedule = prefSchedule;
    });
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: discardChangesToSchedule,
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
