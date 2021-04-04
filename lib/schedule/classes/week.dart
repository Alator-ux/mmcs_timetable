import 'package:schedule/schedule/classes/lesson.dart';

import 'day.dart';
import 'enums.dart';

import '../test_values/test_values.dart';

class Week {
  List<Day> _days;
  Week(List<Day> days) {
    if (days.length != 7) throw Exception("Lenght of the list != 7");
    for (int i = 0; i < days.length; i++) {
      if (days[0].d != DaysOfWeek.values[i])
        throw Exception("Days go out of order");
    }
    _days = days;
  }
  List<Day> get days => _days;

  /*Week.testConstructor() {
    // String tw;
    // if (tweek == TypeWeek.lower)
    //   tw = "нижней недели";
    // else
    //   tw = "верхней недели";
    this._days = new List<Day>();
    for (int i = 0; i < 6; i++) {
      var lessons = List<Lesson>();
      for (int j = 1; j < 6; j++) {
        lessons.add(Lesson.withTimeFromString(
            room: j.toString(),
            subject: "Предмет номер " + j.toString(),
            teacherName: "Преподаватель " + j.toString(),
            time: timesForTest[j - 1]));
      }
      var d = Day(d: DaysOfWeek.values[i], lessons: lessons);
      this._days.add(d);
    }
  }*/
  //set days() {
//
//}
}
