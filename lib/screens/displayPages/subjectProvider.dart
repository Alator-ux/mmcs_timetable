import 'dart:math' show Random;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/notifications/notification_service.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
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
  List<NormalLesson> _tempLessons;

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

  void refresh(List<Week> weeks, UserType userType, TypeOfWeek typeOfWeek) {
    _weeks = weeks;
    _userType = userType;
    _selectedWeek = typeOfWeek;
    _currentWeek = typeOfWeek;
    notifyListeners();
  }

  Future<void> initFromDB(UserType userType, TypeOfWeek typeOfWeek) async {
    List<Week> weeks = [];
    if (userType == UserType.student) {
      weeks = await db.getWeeksForStudent(1);
    } else {
      weeks = await db.getWeeksForTeacher(1);
    }
    return SubjectProvider.create(weeks, userType, typeOfWeek);
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

  void changeCurrentWeek() {
    _selectedWeek =
        _selectedWeek == TypeOfWeek.lower ? TypeOfWeek.upper : TypeOfWeek.lower;
    notifyListeners();
  }

  void replaceLesson(NormalLesson oldLesson, NormalLesson newLesson) {
    var dayID = oldLesson.dayid;
    var ind = _weeks[_selectedWeek.index]
        .days[dayID]
        .normalLessons
        .indexOf(oldLesson);
    if (ind == -1) {
      addNewLesson(newLesson);
    } else {
      _weeks[_selectedWeek.index].days[dayID].normalLessons[ind] = newLesson;
      scheduleAlarms();
      notifyListeners();
    }
  }

  void addNewLesson(NormalLesson newLesson) {
    var dayID = newLesson.dayid;
    newLesson.lessonid = _generateID();
    _weeks[_selectedWeek.index].days[dayID].normalLessons.add(newLesson);
    _weeks[_selectedWeek.index]
        .days[dayID]
        .normalLessons
        .sort((l1, l2) => IntervalOfTime.compare(l1.time, l2.time));
    scheduleAlarms();
    notifyListeners();
  }

  int _generateID() {
    Random random = new Random();
    int generatedID;
    do {
      generatedID = random.nextInt(1000) + 1000;
      //до тех пор пока в каждой недели нет хотя бы одного урока такого айди
    } while (_weeks.any((week) => week.days.any((day) => day.normalLessons
        .any((lesson) => (lesson.lessonid / 10) == generatedID))));
    return generatedID;
  }

  void scheduleAlarms() async {
    alarms = AlarmInfo.alarmsFromList(_weeks, _currentWeek.index);
    var notification = NotificationService();
    await notification.scheduleAlarmList(alarms);
    var notifs = await notification.getNotifs();
    print('');
  }

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
  void temp(List<NormalLesson> lessons) {
    _tempLessons = lessons;
  }

  void deleteFromTemp(NormalLesson lesson) {
    if (_tempLessons != null) {
      var isrem = _tempLessons.remove(lesson);
      print(isrem);
    }
  }

  /// Save temp lessons as main lessons in selected day and week
  void save(int dayID) async {
    if (_tempLessons != null) {
      _weeks[_selectedWeek.index].days[dayID].normalLessons = _tempLessons;
    }
    await db.refreshWeeks(_weeks);
    scheduleAlarms();
    notifyListeners();
  }
}
