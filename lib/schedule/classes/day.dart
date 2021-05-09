import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';

///Каждый элемент соответствует расписанию
class Day {
  // final DaysOfWeek d;
  List<NormalLesson> normalLessons;
  Day() {
    normalLessons = [];
  }
  Day.fromSchedule(Schedule schedules, TypeOfWeek typeOfWeek) {
    normalLessons = [];
    schedules.lessons.forEach(
      (lesson) {
        var curricula =
            schedules.curricula.firstWhere((cur) => cur.lessonid == lesson.id);
        var nLesson = NormalLesson.forDay(lesson, curricula, typeOfWeek);
        normalLessons.add(nLesson);
      },
    );
  }
  bool get isEmpty {
    return normalLessons.isEmpty;
  }
}
