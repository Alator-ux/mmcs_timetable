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

  factory NormalLesson.forDay(Lesson lesson, Curricula curricula,
      List<Group> groups, TypeOfWeek tweek) {
    List<Group> gr = null;
    var uberid = lesson.uberid * 10 + tweek.index;
    if (groups != null) {
      gr = List.generate(groups.length, (index) => Group.copy(groups[index]));
      gr.forEach((group) {
        group.uberid = uberid;
      });
    }
    return NormalLesson(
      // Т.к. normalesson может быть только upper или lower (но не full)
      // это сделано для индивидуальности id
      lessonid: lesson.id * 10 + tweek.index,
      dayid: lesson.day,
      typeOfWeek: tweek,
      groupid: lesson.groupid,
      time: lesson.time,
      subjectname: curricula.subjectname,
      subjectabbr: curricula.subjectabbr,
      teachername: curricula.teachername,
      roomname: curricula.roomname,
      groups: gr,
      uberid: uberid,
    );
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
  factory NormalLesson.empty(int dayid, TypeOfWeek typeOfWeek) {
    return NormalLesson(
      lessonid: 0,
      dayid: dayid,
      subjectname: "",
      subjectabbr: "",
      teachername: "",
      roomname: "",
      time: IntervalOfTime.fromOneString("08:00-09:35"),
      groupid: 0,
      groups: [],
      typeOfWeek: typeOfWeek,
      uberid: 0,
    );
  }
  factory NormalLesson.copy(NormalLesson copyFrom) {
    List<Group> groups = null;
    if (copyFrom.groups != null) {
      groups = List.generate(
          copyFrom.groups.length, (ind) => Group.copy(copyFrom.groups[ind]));
    }

    return NormalLesson(
      dayid: copyFrom.dayid,
      groupid: copyFrom.groupid,
      groups: groups,
      lessonid: copyFrom.lessonid,
      roomname: copyFrom.roomname,
      subjectabbr: copyFrom.subjectabbr,
      subjectname: copyFrom.subjectname,
      teachername: copyFrom.teachername,
      time: IntervalOfTime.copy(copyFrom.time),
      typeOfWeek: copyFrom.typeOfWeek,
      uberid: copyFrom.uberid,
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

  ///Only for teachers
  String groupsAsString() {
    return Group.groupsAsString(groups);
  }

  bool isEqual(NormalLesson other) {
    var res = true;
    res = res && dayid == other.dayid;
    res = res && groupid == other.groupid;
    if (other == null) {
      return false;
    }
    if (groups != null) {
      if (groups.length != other.groups.length) {
        return false;
      }
      for (int groupId = 0; groupId < groups.length; groupId++) {
        var thisGroup = groups[groupId];
        var otherGroup = other.groups[groupId];
        if (!thisGroup.isEqualFroNotPrimitive(otherGroup)) {
          return false;
        }
      }
    }
    res = res && lessonid == other.lessonid;
    res = res && roomname == other.roomname;
    res = res && subjectabbr == other.subjectabbr;
    res = res && subjectname == other.subjectname;
    res = res && teachername == other.teachername;
    res = res && time.isEqual(other.time);
    res = res && typeOfWeek == other.typeOfWeek;
    res = res && uberid == other.uberid;
    return res;
  }
}
