import 'package:flutter/material.dart';
import 'package:schedule/exceptions/my_exceptions.dart';
import 'time.dart';
import 'package:flutter/cupertino.dart';

class Lesson {
  IntervalOfTime _time;
  String _subject;
  String _room;
  final String teacherName;
  Lesson(
      {@required IntervalOfTime time,
      @required String subject,
      @required String room,
      @required this.teacherName}) {
    this._time = time;
    this.subject = subject;
    this.room = room;
  }
  Lesson.withTimeFromString(
      {@required String time,
      @required String subject,
      @required String room,
      @required this.teacherName}) {
    var td1 = IntervalOfTime.timeOfDayFromString(time.substring(0, 5));
    var td2 = IntervalOfTime.timeOfDayFromString(time.substring(6, 11));

    this._time = IntervalOfTime(td1, td2);
    this.subject = subject;
    this.room = room;
  }
  IntervalOfTime get time => _time;

  String get subject => _subject;

  String get room => _room;

  set time(IntervalOfTime time) {
    this._time = time;
  }

  set subject(String subject) {
    if (subject.length < 2)
      throw SubjectNameExcteption("Subject title is too short");
    this._subject = subject;
  }

  set room(String room) {
    var n = int.tryParse(room);
    if (n < 1)
      throw RoomNumberException("number of room can not be less than one");
    this._room = room;
  }
}
