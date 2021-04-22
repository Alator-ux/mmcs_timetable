import 'package:flutter/cupertino.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/week.dart';

class SubjectProvider with ChangeNotifier {
  // final DBProvider db = DBProvider.db;
  List<Week> weeks;
  int curDay = DateTime.now().weekday - 1;
  int curWeek = 0;
  SubjectProvider();
  SubjectProvider.first(this.weeks);

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

  String getCurrentWeek() {
    return curWeek == 0 ? "нижняя неделя" : "верхняя неделя";
  }
}
