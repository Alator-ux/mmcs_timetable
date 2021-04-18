import 'package:schedule/schedule/classes/enums.dart';

import '../time.dart';
part 'lesson.g.dart';
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

  factory Lesson.fromJson(Map<String, dynamic> json, int groupID) =>
      _$LessonFromJson(json, groupID);

  factory Lesson.fromJsonFromDB(Map<String, dynamic> json) =>
      _$LessonFromJsonFromDB(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);
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
