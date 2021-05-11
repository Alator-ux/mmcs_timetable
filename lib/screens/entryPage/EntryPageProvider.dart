import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/connectivity/connectivity_service.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/teacher/teacher.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:path/path.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';

class EntryPageProvider with ChangeNotifier {
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
  EntryPageProvider() {
    connectivity.currentStatus
        .then((value) => isOnline = value == ConnectionStatus.Online);
    _streamSubscription = connectivity.listen(
      (event) {
        isOnline = event == ConnectionStatus.Online;
        notifyListeners();
      },
    );
    _fillGrades();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<void> _fillGrades() async {
    await _fillGradesFromApi();
    // if (await io.File(path).exists()) {
    //   await _fillGradesFromDB();
    // } else {
    //   if (isOnline) {
    //     await _fillGradesFromApi();
    //   }
    // }
  }

  void refresh(BuildContext context) async {
    if (isOnline) {
      await _fillGradesFromApi();
    } else {
      // noConnectionSnackBar(context);
    }
  }

  // Future<void> _fillGradesFromDB() async {
  //   grades = [];
  //   allgroups = [];
  //   teachers = [];

  //   grades = await db.getAllGrades();
  //   List<int> gradeid = [];
  //   await Future.forEach(
  //     grades,
  //     (grade) {
  //       gradeid.add(grade.id);
  //     },
  //   );
  //   allgroups = await db.getAllGroups(gradeid);
  //   teachers = await api.getTeachers(); //TODO delete
  //   changeGradeID(grades.first.id);
  // }

  Future<void> _fillGradesFromApi() async {
    scheduleFilled = false;
    grades = [];
    allgroups = [];
    teachers = [];
    // dbFilled = false;
    grades = await api.getGrades();
    teachers = await api.getTeachers();
    if (teachers.first.name == "") {
      teachers.removeAt(0);
    }
    currentTeacher = teachers.first;
    await Future.forEach(
      grades,
      (grade) async {
        var groups = await api.getGroups(grade.id);
        allgroups.add(groups);
      },
    );
    var typeOfWeekInd = await api.getCurrentWeek();
    typeOfWeek = TypeOfWeek.values[typeOfWeekInd];
    scheduleFilled = true;
    changeGradeID(grades.first.id);
    // await _fillDB(); //TODO сделать заполнение в другом месте
  }

  Future<void> _fillDB() async {
    await db.refreshDb();
    // await db.fillGradeTable(grades);
    // await db.fillAllGroupTable(allgroups);
    dbFilled = true;
    print('vse');
    notifyListeners();
  }

  Future<void> _generateWeeks() async {
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
    print('');
    // await db.fillWeeks(weeks);
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

  List<Group> _groupsOfCurGrade() {
    return allgroups.firstWhere(
        (listOfGroup) => listOfGroup.first.gradeid == currentGradeID);
  }

  Set<String> get currentGroupNames {
    var groups = _groupsOfCurGrade();
    var progs = groups.map((group) => group.name.toString()).toSet();
    return progs;
  }

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
