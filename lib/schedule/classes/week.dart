import 'package:schedule/schedule/classes/enums.dart';
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

  Week(Schedule schedule, TypeOfWeek typeOfWeek) {
    days = [];
    //если пусто расписание пар для группы(которая определяется в generateweeks в entryPageProvider)
    //т.е. если нет совсем ничего, возвращаем пустой список.
    if (schedule == null) {
      for (int i = 0; i < 7; i++) {
        days.add(Day());
      }
      return;
    }
    for (int i = 0; i < 7; i++) {
      // заполняем все уроки данного дня (для людой недели)
      List<Lesson> lessonByDay = [];
      for (var lesson in schedule.lessons) {
        if (lesson.day == i) lessonByDay.add(lesson);
      }
      // заполняем все уроки данного дня для заданном недели
      List<Lesson> lessons = [];
      for (Lesson lesson in lessonByDay) {
        if (typeOfWeekFromString(lesson.typeOfWeek) == typeOfWeek ||
            lesson.typeOfWeek == 'full') {
          lessons.add(lesson);
        }
      }
      if (lessons.isEmpty) {
        Day d = Day();
        days.add(d);
      } else {
        lessons.sort((l1, l2) => IntervalOfTime.compare(l1.time, l2.time));
        var schdl = Schedule(lessons: lessons, curricula: schedule.curricula);
        Day d = Day.fromSchedule(schdl, typeOfWeek);
        days.add(d);
      }
    }
  }
}
