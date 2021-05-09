import 'dart:async';
import 'dart:developer';
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

class EntryPageProvider with ChangeNotifier {
  final api = RestClient.create();
  final connectivity = ConnectivityService();
  DBProvider db = DBProvider.db;
  StreamSubscription _streamSubscription;
  bool dbFilled = true;
  int currentGradeID = 0;
  String currentProgName = '-';
  Group currentGroup = Group(gradeid: 0, id: 0, n: 0, name: '-');
  List<Grade> grades = [];
  List<List<Group>> allgroups = [];
  Map<int, Schedule> schedules = Map<int, Schedule>();
  List<Week> weeks;
  List<Teacher> teachers = [];
  Teacher currentTeacher = Teacher(id: 0, name: "-");
  bool isOnline = false;
  UserType userType = UserType.student;

  EntryPageProvider() {
    connectivity.currentStatus
        .then((value) => isOnline = value == ConnectionStatus.Online);
    _streamSubscription = connectivity.ConnectionStatusController.stream.listen(
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
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, db.dbname);
    if (await io.File(path).exists()) {
      await _fillGradesFromDB();
    } else {
      if (isOnline) {
        await _fillGradesFromApi();
      }
    }
  }

  void refresh(BuildContext context) async {
    if (isOnline) {
      await _fillGradesFromApi();
    } else {
      // noConnectionSnackBar(context);
    }
  }

  Future<void> _fillGradesFromDB() async {
    grades = [];
    allgroups = [];
    schedules = Map<int, Schedule>();
    teachers = [];

    grades = await db.getAllGrades();
    List<int> gradeid = [];
    await Future.forEach(
      grades,
      (grade) {
        gradeid.add(grade.id);
      },
    );
    allgroups = await db.getAllGroups(gradeid);
    schedules = await db.getMap();
    teachers = await api.getTeachers(); //TODO delete
    changeGradeID(grades.first.id);
  }

  Future<void> _fillGradesFromApi() async {
    grades = [];
    allgroups = [];
    schedules = Map<int, Schedule>();
    dbFilled = false;
    grades = await api.getGrades();
    teachers = await api.getTeachers();

    await Future.forEach(
      grades,
      (grade) async {
        var groups = await api.getGroups(grade.id);
        allgroups.add(groups);
      },
    );

    await Future.forEach(
      allgroups,
      (groups) async {
        await Future.forEach(
          groups,
          (group) async {
            int id = group.id;
            var schedule = await api.getSchedule(id);
            schedules[id] = schedule;
          },
        );
      },
    );

    changeGradeID(grades.first.id);
    await _fillDB();
  }

  Future<void> _fillDB() async {
    await db.refreshDb();
    db = DBProvider.db;
    await db.fillGradeTable(grades);
    await db.fillAllGroupTable(allgroups);
    await db.fillSchedule(schedules);
    dbFilled = true;
    notifyListeners();
  }

  Future<void> _generateWeeks() async {
    //TODO если есть в бд, забираем,если нет - генерируем и пушим.
    weeks = [];
    await db.getWeeks(currentGroup.id).then(
      (value) async {
        if (value.isNotEmpty) {
          weeks = value;
          return;
        } else {
          var week = Week(schedules[currentGroup.id], TypeOfWeek.lower);
          weeks.add(week);
          week = Week(schedules[currentGroup.id], TypeOfWeek.upper);
          weeks.add(week);
          await db.fillWeeks(weeks);
        }
      },
    );
  }

  Future<List<Week>> getCurrentSchedule() async {
    await _generateWeeks();
    return weeks;
    //TODO getWeeks и проверку
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
    return !(schedules.isEmpty || !dbFilled);
  }

  bool get canShowTeachers {
    return teachers.isNotEmpty || teachers.first.id != 0;
  }
}
