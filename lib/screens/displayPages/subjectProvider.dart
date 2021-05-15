import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/notifications/notification_service.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/week.dart';

class SubjectProvider with ChangeNotifier {
  final DBProvider db = DBProvider.db;
  static SubjectProvider _instance;
  List<Week> _weeks;
  int _curDay = DateTime.now().weekday - 1;
  TypeOfWeek _selectedWeek;
  TypeOfWeek _currentWeek;
  UserType _userType;
  List<AlarmInfo> alarms;

  SubjectProvider._();
  factory SubjectProvider() {
    _instance ??= SubjectProvider._();
    return _instance;
  }

  factory SubjectProvider.create(
      List<Week> weeks, UserType userType, TypeOfWeek typeOfWeek) {
    var res = SubjectProvider();
    res.refresh(weeks, userType, typeOfWeek);
    return res;
  }

  ///Refresh fields from data
  void refresh(List<Week> weeks, UserType userType, TypeOfWeek typeOfWeek) {
    _weeks = weeks;
    _userType = userType;
    _selectedWeek = typeOfWeek;
    _currentWeek = typeOfWeek;
    notifyListeners();
  }

  ///Init subject provider from db if schedule was saved
  Future<void> initFromDB(UserType userType, TypeOfWeek typeOfWeek) async {
    List<Week> weeks = [];
    if (userType == UserType.student) {
      weeks = await db.getWeeksForStudent(1);
    } else {
      weeks = await db.getWeeksForTeacher(1);
    }
    return SubjectProvider.create(weeks, userType, typeOfWeek);
  }

  ///Fill updateable rows in db from unupdateable
  ///Also fill these weeks
  Future<void> refreshFromDB() async {
    List<Week> weeks = [];
    if (userType == UserType.student) {
      weeks = await db.getWeeksForStudent(0);
    } else {
      weeks = await db.getWeeksForTeacher(0);
    }
    await db.refreshWeeks(weeks);
    return SubjectProvider.create(weeks, userType, _currentWeek);
  }

  Day get currentDay {
    return _weeks[_selectedWeek.index].days[_curDay];
  }

  Day dayByDayID(int dayid) {
    return _weeks[_selectedWeek.index].days[dayid];
  }

  TypeOfWeek get selectedWeek {
    return _selectedWeek;
  }

  TypeOfWeek get currentWeek {
    return _currentWeek;
  }

  UserType get userType {
    return _userType;
  }

  List<Week> get weeks {
    return _weeks;
  }

  void changeSelectedWeek() {
    _selectedWeek =
        _selectedWeek == TypeOfWeek.lower ? TypeOfWeek.upper : TypeOfWeek.lower;
    notifyListeners();
  }

  // void replaceLesson(NormalLesson oldLesson, NormalLesson newLesson) { //TODO удалить
  //   var dayID = oldLesson.dayid;
  //   var ind = _weeks[_selectedWeek.index]
  //       .days[dayID]
  //       .normalLessons
  //       .indexOf(oldLesson);
  //   if (ind == -1) {
  //     addNewLesson(newLesson);
  //   } else {
  //     _weeks[_selectedWeek.index].days[dayID].normalLessons[ind] = newLesson;
  //     scheduleAlarms();
  //     notifyListeners();
  //   }
  // }

  // void addNewLesson(NormalLesson newLesson) { //TODO удалить
  //   var dayID = newLesson.dayid;
  //   // newLesson.lessonid = _generateID();
  //   _weeks[_selectedWeek.index].days[dayID].normalLessons.add(newLesson);
  //   _weeks[_selectedWeek.index]
  //       .days[dayID]
  //       .normalLessons
  //       .sort((l1, l2) => IntervalOfTime.compare(l1.time, l2.time));
  //   scheduleAlarms();
  //   notifyListeners();
  // }

  ///Schedule notifications for ~ a month
  void scheduleAlarms() async {
    alarms = AlarmInfo.alarmsFromList(_weeks, _currentWeek.index);
    var notification = NotificationService();
    await notification.scheduleAlarmList(alarms);
    var notifs = await notification.getNotifs();
    print('');
  }

  ///Schedule cancel all scheduled alarms
  void cancelAlarms() async {
    var notification = NotificationService();
    await notification.cancelAll();
  }

  void aaa() async {
    var notification = NotificationService();
    var notifs = await notification.getNotifs();
    notifs.forEach((element) {
      print(element.body + " " + element.title + " " + element.payload);
    });
    var aaaaa =
        notifs.where((elem) => elem.payload == "2021-05-10 08:00:00.000+0300");
    aaaaa.forEach((element) {
      print(element.payload);
    });
    print('');
  }

  /// Set temp lessons. On call function "save" this lessons
  /// will be saved as main lessons in selected day and week
  // void temp(List<NormalLesson> lessons) {
  //   _tempLessons = lessons;
  // }

  /// Save temp lessons as main lessons in selected day and week
  Future<void> save({int dayId, List<NormalLesson> lessons}) async {
    if (lessons != null) {
      _weeks[_selectedWeek.index].days[dayId].normalLessons = lessons;

      await db.refreshWeeks(_weeks);
      scheduleAlarms();
      notifyListeners();
    }
  }
}
