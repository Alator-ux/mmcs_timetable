import 'dart:async';
import 'package:flutter/material.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/connectivity/connectivity_service.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/teacher/teacher.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';

class EntryPageProvider with ChangeNotifier {
  static EntryPageProvider _instance;
  final api = RestClient.create();
  final connectivity = ConnectivityService();
  DBProvider db = DBProvider.db;
  StreamSubscription _streamSubscription;
  bool dbFilled = true;
  bool scheduleFilled = false;
  int currentGradeID = 0;
  String currentProgName = '-';
  Group currentGroup = Group(gradeid: 0, id: 0, n: 0, name: '-');
  Schedule schedule;
  List<Grade> grades = [];
  List<List<Group>> allgroups = [];
  List<Week> weeks;
  List<Teacher> teachers = [];
  Teacher currentTeacher = Teacher(id: 0, name: "-");
  bool isOnline = false;
  UserType userType = UserType.student;
  TypeOfWeek typeOfWeek;
  EntryPageProvider._() {
    connectivity.currentStatus
        .then((value) => isOnline = value == ConnectionStatus.Online);
    _streamSubscription = connectivity.listen(
      (event) {
        isOnline = event == ConnectionStatus.Online;
        if (isOnline) {
          _fillGrades();
        }
        notifyListeners();
      },
    );
  }

  factory EntryPageProvider() {
    _instance ??= EntryPageProvider._();
    return _instance;
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<void> _fillGrades() async {
    await _fillGradesFromApi();
  }

  Future<void> _fillGradesFromApi() async {
    if (!isOnline) {
      return;
    }

    scheduleFilled = false;
    grades = [];
    allgroups = [];
    teachers = [];
    grades = await api.getGrades();
    teachers = await api.getTeachers();

    var invalidTeachers =
        teachers.where((teacher) => teacher.name == "").toList();
    if (invalidTeachers.length != 0) {
      invalidTeachers.forEach(
        (invalidTeacher) {
          //Как-то раз обычный ремув по экземпляру класса не работал. По этой причине не рискую *орех справедливости*
          var ind = teachers.indexOf(invalidTeacher);
          teachers.removeAt(ind);
        },
      );
    }

    currentTeacher = teachers.first;
    await Future.forEach(
      grades,
      (Grade grade) async {
        var groups = await api.getGroups(grade.id);
        groups.forEach(
          (group) {
            group.degree = grade.degree;
            group.gradenum = grade.n;
            group.groupnum = group.n;
          },
        );
        allgroups.add(groups);
      },
    );
    var typeOfWeekInd = await api.getCurrentWeek();
    typeOfWeek = TypeOfWeek.values[typeOfWeekInd];
    scheduleFilled = true;
    changeGradeID(grades.first.id);
  }

  Future<void> _generateWeeks() async {
    if (!isOnline) {
      return;
    }
    weeks = [];
    bool areWeeksOld = false;
    int id = 0;
    if (userType == UserType.student) {
      id = currentGroup.id;
      schedule = await api.getSchedule(id);
      weeks = await db.getWeeksForStudent(1);
    } else {
      id = currentTeacher.id;
      schedule = await api.getScheduleOfTeacher(id);
      weeks = await db.getWeeksForTeacher(1);
    }

    var settings = SettingsProvider();
    if (settings.isSaved) {
      if (settings.userType == UserType.student &&
          userType == UserType.student) {
        areWeeksOld =
            weeks.any((week) => week.days.any((day) => day //TODO firstwhere?
                .normalLessons
                .any((lesson) => lesson.groupid == currentGroup.id)));
      } else if (settings.userType == UserType.teacher &&
          userType == UserType.teacher) {
        areWeeksOld = weeks.any((week) => week.days.any((day) => day
            .normalLessons
            .any((lesson) => lesson.teachername == currentTeacher.name)));
      } else {
        areWeeksOld = false;
      }
    }

    //TODO сделать нормально

    if (!areWeeksOld) {
      settings.setUTandToW(
          userType: userType, typeOfWeek: typeOfWeek, newId: id);
      settings.overWrite = true;
      weeks = [];
    } else if (weeks.isNotEmpty) {
      settings.overWrite = false;
      return;
    }

    var week = Week(schedule, TypeOfWeek.lower);
    weeks.add(week);
    week = Week(schedule, TypeOfWeek.upper);
    weeks.add(week);
  }

  Future<List<Week>> getCurrentSchedule() async {
    await _generateWeeks();
    return weeks;
  }

  void changeGradeID(int newid) {
    currentGradeID = newid;
    var group = allgroups
        .firstWhere((grade) => grade.any((gr) => gr.gradeid == currentGradeID))
        .first;
    changeGroup(group);
  }

  void changeGroup(Group group) {
    currentGroup = group;
    var progName = group.name;
    changeProgName(progName);
  }

  void changeProgName(String progName) {
    currentProgName = progName;
    notifyListeners();
  }

  void changeUserType(UserType newUserType) {
    userType = newUserType;
    notifyListeners();
  }

  void changeTeacher(Teacher teacher) {
    currentTeacher = teacher;
    notifyListeners();
  }

  ///Return all groups of the current grade
  List<Group> _groupsOfCurGrade() {
    return allgroups.firstWhere(
        (listOfGroup) => listOfGroup.first.gradeid == currentGradeID);
  }

  ///Returns all group names of the current grade
  Set<String> get currentGroupNames {
    var groups = _groupsOfCurGrade();
    var progs = groups.map((group) => group.name.toString()).toSet();
    return progs;
  }

  ///Returns all groups of the current grade
  List<Group> get currentGroups {
    var groups = _groupsOfCurGrade();
    var res = groups.where((group) => group.name == currentProgName);
    return res.toList();
  }

  bool get canShowGrades {
    return grades.isNotEmpty;
  }

  bool get canShowGroups {
    return !(allgroups.isEmpty || allgroups.first.first.id == 0);
  }

  bool get canGetSchedule {
    return schedule != null && dbFilled;
  }

  bool get canShowTeachers {
    if (teachers.isNotEmpty) {
      return teachers.first.id != 0;
    } else {
      return false;
    }
  }
}
