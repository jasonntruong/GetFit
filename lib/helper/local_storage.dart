/// Local storage functions

import 'package:shared_preferences/shared_preferences.dart';

/// Saves string value to storage
saveToStorage(String key, String value) async {
  await SharedPreferences.getInstance()
      .then((prefs) => {prefs.setString(key, value)});
}

/// Gets string value from storage
getFromStorage(String key) async {
  String? savedValue;
  await SharedPreferences.getInstance()
      .then((prefs) => {savedValue = prefs.getString(key)});
  return savedValue;
}

/// Updates lastUpdated
saveLastUpdated({String? date}) async {
  await SharedPreferences.getInstance().then((prefs) =>
      {prefs.setString('lastUpdated', date ?? DateTime.now().toString())});
}
