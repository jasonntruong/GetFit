/// Stats helper functions

import 'package:get_fit/helper/local_storage.dart';

Future<double> getOwed() async {
  return double.parse(await getFromStorage('owed') ?? "0.00");
}

Future<double> getDonated() async {
  return double.parse(await getFromStorage('donated') ?? "0.00");
}

Future<int> getDaysSkipped() async {
  return int.parse(await getFromStorage('skipped') ?? "0");
}

increaseOwed({double amount = 2.00}) async {
  double current = await getOwed();
  current += amount;
  await saveToStorage('owed', current.toStringAsFixed(2));
}

decreaseOwed({double amount = 2.00}) async {
  double current = await getOwed();
  current -= amount;
  await saveToStorage('owed', current.toStringAsFixed(2));
}

increaseDaySkipped({int days = 1}) async {
  int current = await getDaysSkipped();
  current += days;
  await saveToStorage('skipped', current.toString());
}

payPayment() async {
  double owed = await getOwed();
  double donated = await getDonated();
  donated += owed;
  await saveToStorage('owed', '0.00');
  await saveToStorage('donated', donated.toStringAsFixed(2));
}
