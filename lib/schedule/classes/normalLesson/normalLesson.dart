import 'package:schedule/schedule/classes/curricula/curricula.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';

import '../time.dart';

class NormalLesson {
  int lessonid;
  int groupid;
  String typeOfWeek;
  int dayid;
  IntervalOfTime time;
  String subjectname;
  String subjectabbr;
  String teachername;
  String roomname;

  NormalLesson(
      {this.lessonid,
      this.groupid,
      this.time,
      this.subjectname,
      this.subjectabbr,
      this.teachername,
      this.roomname,
      this.typeOfWeek,
      this.dayid});

  NormalLesson.forDay(Lesson lesson, Curricula curricula, String tweek,
      int dayID, int groupID) {
    dayid = dayID;
    typeOfWeek = tweek;
    lessonid = lesson.id;
    groupid = groupID;
    time = lesson.time;
    subjectname = curricula.subjectname;
    subjectabbr = curricula.subjectabbr;
    teachername = curricula.teachername;
    roomname = curricula.roomname;
  }
  factory NormalLesson.fromJson(Map<String, dynamic> json) {
    String jsonTime = json['time'];
    String begin = jsonTime.substring(0, 5);
    String end = jsonTime.substring(8, 13);
    IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
    return NormalLesson(
      lessonid: json['lessonid'] as int,
      groupid: json['groupid'] as int,
      typeOfWeek: json['typeOfWeek'] as String,
      dayid: json['dayid'],
      time: _time,
      subjectname: json['subjectname'] as String,
      subjectabbr: json['subjectabbr'] as String,
      teachername: json['teachername'] as String,
      roomname: json['roomname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonid': lessonid,
      'groupid': groupid,
      'typeOfWeek': typeOfWeek,
      'dayid': dayid,
      'time': time.asString(),
      'subjectname': subjectname,
      'subjectabbr': subjectabbr,
      'teachername': teachername,
      'roomname': roomname,
    };
  }
}
