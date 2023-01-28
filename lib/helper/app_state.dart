import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_fit/alerts/alert.dart';
import 'package:get_fit/helper/local_storage.dart';
import 'package:get_fit/helper/stats.dart';

import '../main.dart';

Map<String, String> appStates = {
  "DEFAULT": "DEFAULT",
  "IMAGE": "IMAGE",
  "SKIPPED": "SKIPPED",
  "CONFIRMED": "CONFIRMED",
  "UNCONFIRMED": "UNCONFIRMED"
};

/// On IMAGE state set tab as Home
onImage() async {
  if (appState != appStates["IMAGE"]) {
    await saveToStorage('appState', appStates["IMAGE"]!);
  }
  appState = appStates["IMAGE"]!;
  activeTab = tabs["HOME"]!;
}

/// On SKIPPED state increment days skipped and amount owed
onSkipped() async {
  if (appState != appStates["SKIPPED"]) {
    await saveToStorage('appState', appStates["SKIPPED"]!);
    await saveToStorage('imagePath', "");
    // remove old imgPath
    imgPath = "";
    await increaseDaySkipped();
    await increaseOwed();
  }
  appState = appStates["SKIPPED"]!;
}

/// On CONFIRMED state
onConfirmed() async {
  if (appState != appStates["CONFIRMED"]) {
    await saveToStorage('appState', appStates["CONFIRMED"]!);
  }
  appState = appStates["CONFIRMED"]!;
}

/// On UNCONFIRMED state show alert to confirm
onUnconfirmed(context) async {
  if (appState != appStates["UNCONFIRMED"]) {
    await saveToStorage('appState', appStates["UNCONFIRMED"]!);
    showAlert2Actions(context, "Confirm Schedule",
        "\nPlease press save to confirm your schedule", "Ok", () {
      Navigator.pop(context);
    }, "No", () => {});
  }
  appState = appStates["UNCONFIRMED"]!;
  activeTab = tabs["SCHEDULE"]!;
}

/// Polls for the app state
pollAppState(BuildContext context) async {
  DateTime currentDT = DateTime.now();
  imgPath = await getFromStorage('imagePath') ?? "";

  // Set appState if not set
  if (appState == "") {
    String? appStateFromStorage = await getFromStorage('appState');
    if (appStateFromStorage == null) {
      saveToStorage('appState', appStates["DEFAULT"]!);
    }
    appState = await getFromStorage('appState');
  }

  String? lastUpdatedString = await getFromStorage('lastUpdated');
  if (lastUpdatedString == null) {
    // Occurs on app's first launch
    saveLastUpdated(date: currentDT.toString());
  } else {
    var notifications =
        jsonDecode(await getFromStorage('notifications') ?? "{}");
    DateTime lastUpdated = DateTime.parse(lastUpdatedString);

    try {
      DateTime startOfCapture =
          DateTime.parse(notifications[currentDT.weekday.toString()]);
      DateTime endOfCapture = startOfCapture.add(const Duration(minutes: 2));

      if (lastUpdated.isBefore(startOfCapture)) {
        if (currentDT.isAfter(startOfCapture) &&
            currentDT.isBefore(endOfCapture)) {
          // IMAGE state
          await onImage();
        }
        if (currentDT.isAfter(endOfCapture)) {
          // SKIPPED state
          await onSkipped();
        }
        return;
      }
    } catch (e) {}
    try {
      DateTime confirm = DateTime.parse(notifications["8"]);

      if (currentDT.isAfter(confirm)) {
        if (lastUpdated.isBefore(confirm)) {
          // UNCONFIRMED state
          await onUnconfirmed(context);
        } else {
          // CONFIRMED state
          await onConfirmed();
        }
        return;
      }
    } catch (e) {}

    appState = appStates["DEFAULT"]!;
  }
}
