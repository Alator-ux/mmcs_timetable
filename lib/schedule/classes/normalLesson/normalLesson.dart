import 'package:schedule/schedule/classes/curricula/curricula.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';

import '../time.dart';

class NormalLesson {
  int lessonID;
  int curriculaID;
  IntervalOfTime time;
  String subjectname;
  String subjectabbr;
  String teachername;
  String roomname;
  NormalLesson(Lesson lesson, Curricula curricula) {
    lessonID = lesson.id;
    curriculaID = curricula.id;
    time = lesson.time;
    subjectname = curricula.subjectname;
    subjectabbr = curricula.subjectabbr;
    teachername = curricula.teachername;
    roomname = curricula.roomname;
  }
}
