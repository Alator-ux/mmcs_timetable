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

  factory IntervalOfTime.fromOneString(String time) {
    var beginAsString = time.substring(0, 5);
    var endAsString = time.substring(6, 11);
    return IntervalOfTime.fromString(beginAsString, endAsString);
  }

  String asString() {
    return beginAsString() + " - " + endAsString();
  }

  String beginAsString() {
    return this.begin.toString().substring(10, 15);
  }

  String beginHourAsString() {
    return this.begin.toString().substring(10, 12);
  }

  String endAsString() {
    return this.end.toString().substring(10, 15);
  }

  bool isEqual(IntervalOfTime other) {
    var res = true;
    res = res && begin == other.begin;
    res = res && end == other.end;
    return res;
  }

  static int compare(IntervalOfTime t1, IntervalOfTime t2) {
    if (t1.begin.hour > t2.begin.hour) {
      return 1;
    }
    if (t1.begin == t2.begin) {
      return 0;
    }
    if (t1.begin.hour < t2.begin.hour) {
      return -1;
    }
    //t1.begin.hour == t2.begin.hour && t1.begin.minute != t2.begin.minute
    if (t1.begin.minute < t2.begin.minute) {
      return -1;
    }
    //if (t1.begin.minute >= t2.begin.minute)
    else {
      return 1;
    }
  }

  static bool compareTimeOfDay(TimeOfDay t1, TimeOfDay t2) {
    if (t1.hour > t2.hour) {
      return true;
    }
    if (t1.hour == t2.hour) {
      if (t1.minute == t2.minute) {
        return false;
      }
    }
    if (t1.hour < t2.hour) {
      return false;
    }
    //t1.begin.hour == t2.begin.hour && t1.begin.minute != t2.begin.minute
    if (t1.minute < t2.minute) {
      return false;
    }
    //if (t1.begin.minute >= t2.begin.minute)
    else {
      return true;
    }
  }

  static TimeOfDay timeOfDayFromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  bool isCrossed(IntervalOfTime other) {
    if (begin.hour == other.end.hour) if (begin.minute < other.begin.minute)
      return true;

    if (begin.hour > other.begin.hour) return true;

    return false;
  }
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
