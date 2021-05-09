import 'package:schedule/schedule/classes/curricula/curricula.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';

import '../time.dart';

class NormalLesson {
  int lessonid;
  int groupid;
  // это поле в бд хранится в отдельной таблице,
  // так что при fromJson и toJson его обрабатывать надо отдельно
  List<Group> groups;
  TypeOfWeek typeOfWeek;
  int dayid;
  int uberid;
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
      this.dayid,
      this.groups,
      this.uberid});

  NormalLesson.forDay(Lesson lesson, Curricula curricula, TypeOfWeek tweek) {
    // Т.к. normalesson может быть только upper или lower (но не full)
    // это сделано для индивидуальности id
    lessonid = lesson.id * 10 + tweek.index;
    dayid = lesson.day;
    typeOfWeek = tweek;
    groupid = lesson.groupid;
    time = lesson.time;
    subjectname = curricula.subjectname;
    subjectabbr = curricula.subjectabbr;
    teachername = curricula.teachername;
    roomname = curricula.roomname;
    groups = lesson.groups;
    uberid = lesson.uberid;
  }
  factory NormalLesson.fromJson(Map<String, dynamic> json) {
    String jsonTime = json['time'];
    String begin = jsonTime.substring(0, 5);
    String end = jsonTime.substring(8, 13);
    IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
    String tweekAsString = json['typeOfWeek'] as String;
    TypeOfWeek tweek = typeOfWeekFromString(tweekAsString);

    return NormalLesson(
      lessonid: json['lessonid'] as int,
      groupid: json['groupid'] as int,
      typeOfWeek: tweek,
      dayid: json['dayid'] as int,
      uberid: json['uberid'] as int,
      time: _time,
      subjectname: json['subjectname'] as String,
      subjectabbr: json['subjectabbr'] as String,
      teachername: json['teachername'] as String,
      roomname: json['roomname'] as String,
      groups: null, //вручную задать значение в бд
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonid': lessonid,
      'groupid': groupid,
      'typeOfWeek': typeOfWeek.toJsonString(),
      'dayid': dayid,
      'time': time.asString(),
      'subjectname': subjectname,
      'subjectabbr': subjectabbr,
      'teachername': teachername,
      'roomname': roomname,
      'uberid': uberid,
    };
  }
}
