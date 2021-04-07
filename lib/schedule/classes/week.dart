import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'day.dart';
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
    for (int i = 0; i < 7; i++) {
      List<Lesson> lessonByDay = [];
      for (var lesson in schedule.lessons) {
        if (lesson.day == i) lessonByDay.add(lesson);
      }
      List<Lesson> lessons = [];
      for (Lesson lesson in lessonByDay) {
        if (lesson.typeOfWeek == typeOfWeek || lesson.typeOfWeek == 'full') {
          lessons.add(lesson);
        }
      }
      if (lessons.isEmpty) {
        Day d = Day();
        days.add(d);
      } else {
        lessons.sort((l1, l2) => IntervalOfTime.compare(l1.time, l2.time));
        var schdl = Schedule(lessons: lessons, curricula: schedule.curricula);
        Day d = Day.fromSchedule(schdl, typeOfWeek, i, groupID);
        days.add(d);
      }
    }
  }
}
