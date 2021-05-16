import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/notifications/notification_service.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/grade/grade.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/week.dart';

class SubjectProvider with ChangeNotifier {
  final DBProvider db = DBProvider.db;
  static SubjectProvider _instance;
  List<Week> _weeks;
  List<Grade> _grades;
  List<List<Group>> _allgroups;
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

  factory SubjectProvider.create(List<Week> weeks, List<Grade> grades,
      List<List<Group>> allgroups, UserType userType, TypeOfWeek typeOfWeek) {
    var res = SubjectProvider();
    res.refresh(weeks, userType, typeOfWeek);
    res._allgroups = allgroups;
    res._grades = grades;
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
    var grades = await db.getAllGrades();
    List<int> gradeid = [];
    await Future.forEach(
      grades,
      (grade) {
        gradeid.add(grade.id);
      },
    );
    var allGroups = await db.getAllGroups(gradeid);
    return SubjectProvider.create(
        weeks, grades, allGroups, userType, typeOfWeek);
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
    refresh(weeks, userType, currentWeek);
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

  List<List<Group>> get allGroups {
    return _allgroups;
  }

  List<Grade> get grades {
    return _grades;
  }

  void changeSelectedWeek() {
    _selectedWeek =
        _selectedWeek == TypeOfWeek.lower ? TypeOfWeek.upper : TypeOfWeek.lower;
    notifyListeners();
  }

  ///Schedule notifications for ~ a month
  void scheduleAlarms() async {
    alarms = AlarmInfo.alarmsFromList(_weeks, _currentWeek.index);
    var notification = NotificationService();
    await notification.scheduleAlarmList(alarms);
  }

  ///Schedule cancel all scheduled alarms
  void cancelAlarms() async {
    var notification = NotificationService();
    await notification.cancelAll();
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
