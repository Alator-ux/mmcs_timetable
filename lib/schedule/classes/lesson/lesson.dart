import 'package:schedule/schedule/classes/enums.dart';

import '../time.dart';
// import 'package:flutter/cupertino.dart';

//@JsonSerializable()
class Lesson {
  int id;
  int groupid;
  IntervalOfTime time;
  int day;
  String typeOfWeek;
  Lesson({this.time, this.day, this.id, this.groupid, this.typeOfWeek});

  // Lesson.withTimeFromString(
  //     {@required String time, @required int id, @required int uberid}) {
  //   var td1 = IntervalOfTime.timeOfDayFromString(time.substring(0, 5));
  //   var td2 = IntervalOfTime.timeOfDayFromString(time.substring(6, 11));

  //   this.time = ''; //IntervalOfTime(td1, td2);
  //   this.id = id;
  //   this.uberid = uberid;
  // }

  factory Lesson.fromJson(Map<String, dynamic> json, int groupID) {
    String jsonTime = json['timeslot'];
    String begin = jsonTime.substring(3, 8);
    String end = jsonTime.substring(12, 17);
    int indOfDay = int.parse(jsonTime[1]);
    if (indOfDay > 5) {
      print(begin);
    }
    print(end);
    IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
    String tweek = jsonTime.substring(21, jsonTime.length - 1);
    return Lesson(
      time: _time,
      day: indOfDay,
      id: json['id'] as int,
      groupid: groupID,
      typeOfWeek: tweek,
    );
  }

  factory Lesson.fromJsonFromDB(Map<String, dynamic> json) {
    String jsonTime = json['time'];
    String begin = jsonTime.substring(0, 5);
    String end = jsonTime.substring(8, 13);
    int indOfDay = json['day'];
    IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
    // String tweek = jsonTime.substring(21, jsonTime.length - 1);
    return Lesson(
      time: _time,
      day: indOfDay,
      id: json['id'] as int,
      groupid: json['groupid'] as int,
      typeOfWeek: json['typeOfWeek'],
    );
  }

  Map<String, dynamic> toJson() {
    String time = this.time.asString();
    return {
      'time': time,
      'day': day,
      'id': id,
      'groupid': groupid,
      'typeOfWeek': typeOfWeek,
    };
  }
  /*IntervalOfTime get time => _time;

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
  }*/
}
