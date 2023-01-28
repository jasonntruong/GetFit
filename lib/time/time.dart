/// Time helper functions

import 'dart:math';

final _random = Random();

/// Parse time from schedule to 24 hour time object (i.e 2:30 PM => {hour: 14, minute: 30})
Map<String, int> parseTime(String time) {
  var numbers = time.split(':');
  int hours = int.parse(numbers[0]);
  var minutesAndAMPM = numbers[1].split(' ');
  int minutes = int.parse(minutesAndAMPM[0]);
  String AMPM = minutesAndAMPM[1];
  if (AMPM == "PM" && hours != 12) {
    hours += 12;
  }
  if (AMPM == "AM" && hours == 12) {
    hours -= 12;
  }
  return {"hour": hours, "minute": minutes};
}

/// Picks a random time between the start and end params given
pickRandomTime(String start, String end) async {
  var parsedStart = parseTime(start);
  var parsedEnd = parseTime(end);

  int startInMinutes = parsedStart["hour"]! * 60 + parsedStart["minute"]!;
  int endInMinutes = parsedEnd["hour"]! * 60 + parsedEnd["minute"]!;
  int randomTime =
      startInMinutes + _random.nextInt(endInMinutes - startInMinutes);
  int randomHour = (randomTime / 60).floor();
  int randomMinutes = randomTime - randomHour * 60;

  String randomTimeString =
      randomHour.toString() + ':' + randomMinutes.toString() + ":00";
  if (randomMinutes < 10) {
    randomTimeString =
        randomHour.toString() + ':0' + randomMinutes.toString() + ":00";
  }
  if (randomHour < 10) {
    randomTimeString = "0" + randomTimeString;
  }
  return randomTimeString;
}
