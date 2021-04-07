import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/lesson.dart';
import 'package:schedule/schedule/classes/time.dart';

import 'day.dart';
import 'enums.dart';
import 'lesson/lesson.dart';

// import '../test_values/test_values.dart';

///Каждый элемент соответсвует дню недели
class Week {
  List<Day> days;
  Week.fromDB() {
    days = [];
    for (int i = 0; i < 7; i++) {
      days.add(Day());
    }
  }
  Week(Schedule schedule, String typeOfWeek, int groupID) {
    days = [];
    for (int i = 0; i <= 7; i++) {
      var lessons = schedule.lessons
          .where((lesson) =>
              lesson.day == i &&
              (lesson.typeOfWeek == typeOfWeek || lesson.typeOfWeek == 'full'))
          .toList();
      if (lessons.isEmpty) {
        Day d = Day();
        days.add(d);
      } else {
        if (lessons.length == 2) {
          print('');
        }
        lessons.sort((l1, l2) => IntervalOfTime.compare(l1.time, l2.time));
        var schdl = Schedule(lessons: lessons, curricula: schedule.curricula);
        Day d = Day.fromSchedule(schdl, typeOfWeek, i, groupID);
        days.add(d);
      }
    }
  }
  // Week(List<Day> days) {
  //   if (days.length != 7) throw Exception("Lenght of the list != 7");
  //   for (int i = 0; i < days.length; i++) {
  //     if (days[0].d != DaysOfWeek.values[i])
  //       throw Exception("Days go out of order");
  //   }
  //   _days = days;
  // }
  // List<Day> get days => _days;

  // Week.testConstructor() {
  //   // String tw;
  //   // if (tweek == TypeWeek.lower)
  //   //   tw = "нижней недели";
  //   // else
  //   //   tw = "верхней недели";
  //   this.days = [];
  //   for (int i = 0; i < 6; i++) {
  //     var lessons = [];
  //     for (int j = 1; j < 6; j++) {
  //       lessons.add(Schedule());
  //     }
  //     var d = Day(d: DaysOfWeek.values[i], lessons: lessons);
  //     this._days.add(d);
  //   }
  // }
  //set days() {
//
//}
}
