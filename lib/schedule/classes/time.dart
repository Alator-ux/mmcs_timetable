import 'package:flutter/material.dart';

class IntervalOfTime {
  final TimeOfDay begin;
  final TimeOfDay end;

  const IntervalOfTime(this.begin, this.end);

  factory IntervalOfTime.fromString(String beginAsString, String endAsString) {
    var begin = timeOfDayFromString(beginAsString);
    var end = timeOfDayFromString(endAsString);
    return IntervalOfTime(begin, end);
  }

  static TimeOfDay timeOfDayFromString(String timeAsString) {
    String time = timeAsString[0] + timeAsString[1];
    var hour = int.tryParse(time);
    if (hour == null) throw Exception("timeAsString can not be parsed");
    time = timeAsString[3] + timeAsString[4];
    var minute = int.tryParse(time);
    if (minute == null) throw Exception("timeAsString can not be parsed");
    return TimeOfDay(hour: hour, minute: minute);
  }

  String asString() {
    return beginAsString() + " - " + endAsString();
  }

  String beginAsString() {
    return this.begin.toString().substring(10, 15);
  }

  String endAsString() {
    return this.end.toString().substring(10, 15);
  }

  //TODO bool isCrossed(IntervalOfTime other) {}
}

bool areTimesCorrect(TimeOfDay begin, TimeOfDay end) {
  if (begin.hour > end.hour) return false;
  if (begin.hour == end.hour) {
    if (begin.minute > end.minute) return false;
  }

  return true;
}

bool areTimesCorrectByInt(int beginH, int beginM, int endH, int endM) {
  return areTimesCorrect(TimeOfDay(hour: beginH, minute: beginM),
      TimeOfDay(hour: endH, minute: endM));
}
