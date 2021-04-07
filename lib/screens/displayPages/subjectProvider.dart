import 'package:flutter/cupertino.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/week.dart';

class SubjectProvider with ChangeNotifier {
  final DBProvider db = DBProvider.db;
  TextStyle textStyle;
  static List<Week> weeks;
  static int dayIDToChange;
  static int curDay = 2;
  static int curWeek = 1;
  // SubjectProvider();
  SubjectProvider();
  SubjectProvider.first(List<Week> w) {
    weeks = w;
  }

  Day get currentDay {
    return weeks[curWeek].days[curDay];
  }

  Day dayByDayID(int dayid) {
    return weeks[curWeek].days[dayid];
  }

  void changeCurrentWeek() {
    curWeek = curWeek == 0 ? 1 : 0;
    notifyListeners();
  }

  void changeScheduleByLessonID(int id) {}
}
