import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_fit/title.dart';
import 'package:get_fit/tab.dart';
import 'package:get_fit/schedule.dart';

void main() {
  runApp(const GetFit());
}

class GetFit extends StatelessWidget {
  const GetFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        title: 'GetFit.',
        theme: CupertinoThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.black,
            textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(color: Colors.white, fontSize: 16.0))),
        home: GetFitHome(title: 'GetFit.'));
  }
}

class GetFitHome extends StatefulWidget {
  const GetFitHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GetFitHome> createState() => _GetFitHomeState();
}

class _GetFitHomeState extends State<GetFitHome> {
  final FRIENDS_TAB = 'My Friends';
  final SCHEDULE = 'Schedule';
  String _activeTab = '';
  void setActiveTab(tabTitle) {
    setState(() {
      _activeTab = tabTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_activeTab == '') setActiveTab(FRIENDS_TAB);
    return CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TopTitle(name: widget.title),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SelectionTabs(
                        titles: [FRIENDS_TAB, SCHEDULE],
                        activeTab: _activeTab,
                        onSelect: (String title) => setActiveTab(title)),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _activeTab == FRIENDS_TAB
                          ? const Text("hello")
                          : const WeeklySchedule(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
