import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_fit/alerts/alert.dart';
import 'package:get_fit/helper/app_state.dart';
import 'package:get_fit/camera/camera.dart';
import 'package:get_fit/schedule.dart';
import 'package:camera/camera.dart';
import 'package:get_fit/alerts/notification.dart';
import 'package:get_fit/tabs/tab_selector.dart';
import 'package:get_fit/text/title.dart';

import 'home.dart';

late List<CameraDescription> _cameras;
NotificationController? notificationController;

String appState = "";

Map<String, String> tabs = {
  "HOME": 'Home',
  "SCHEDULE": 'Schedule',
};
String activeTab = tabs["HOME"]!;

// imgPath is updated from storage in app_state
String imgPath = "";

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
  Timer? timer;

  /// Sets active tab
  void setActiveTab(tabTitle) {
    if (appState != appStates["IMAGE"] &&
        appState != appStates["UNCONFIRMED"]) {
      setState(() {
        activeTab = tabTitle;
      });
    }
    if (appState == appStates["IMAGE"]) {
      showAlert1Action(context, "Take an Image",
          "\nYou cannot switch tabs until you've taken an image", "Ok", null);
    } else if (appState == appStates["UNCONFIRMED"]) {
      showAlert1Action(
          context,
          "Confirm schedule",
          "\nYou cannot switch tabs until you've confirmed your schedule",
          "Ok",
          null);
    }
  }

  @override
  void initState() {
    super.initState();
    notificationController!.setContext(context);
    pollAppState(context).then((s) => {
          setState(() {
            activeTab;
          })
        });

    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) async {
      await pollAppState(context);
      setState(() {
        activeTab;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (activeTab == '') setActiveTab(tabs["HOME"]);
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
                    TabSelector(
                        titles: [tabs["HOME"]!, tabs["SCHEDULE"]!],
                        activeTab: activeTab,
                        onSelect: (String title) => setActiveTab(title)),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: activeTab == tabs["HOME"]
                            ? appState == appStates["IMAGE"]
                                ? CameraView(
                                    cameras: _cameras,
                                  )
                                : Home(imagePath: imgPath)
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
