import 'package:flutter/cupertino.dart';
import 'package:get_fit/camera.dart';
import 'package:get_fit/title.dart';
import 'package:get_fit/tab.dart';
import 'package:get_fit/schedule.dart';
import 'package:camera/camera.dart';
import 'package:get_fit/notification.dart';

late List<CameraDescription> _cameras;
NotificationController? notificationController;

String _customModelPath = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  notificationController = NotificationController();
  await notificationController!.setupNotifications();
  runApp(const GetFit());
}

class GetFit extends StatelessWidget {
  const GetFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        title: 'GetFit.',
        theme: CupertinoThemeData(
            primaryColor: CupertinoColors.white,
            scaffoldBackgroundColor: CupertinoColors.black,
            textTheme: CupertinoTextThemeData(
                textStyle:
                    TextStyle(color: CupertinoColors.white, fontSize: 16.0))),
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
      // removes any overflow
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            ),
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
                      Expanded(
                        flex: 1,
                        child: _activeTab == FRIENDS_TAB
                            ? CameraView(
                                cameras: _cameras, modelPath: _customModelPath)
                            : ScheduleTab(
                                notificationController: notificationController,
                              ),
                      ),
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
