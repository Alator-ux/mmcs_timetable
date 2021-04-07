import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/connectivity/connectivity_service.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:path/path.dart';

class EntryPageProvider with ChangeNotifier {
  final api = RestClient.create();
  final connectivity = ConnectivityService().ConnectionStatusController.stream;
  final DBProvider db = DBProvider.db;
  bool dbFilled = true;
  int currentGradeID = 0;
  String currentProgName = '-';
  Group currentGroup = Group(gradeid: 0, id: 0, n: 0, name: '-');
  List<Grade> grades = [];
  List<List<Group>> allgroups = [];
  Map<int, Schedule> schedules = Map<int, Schedule>();
  List<Week> weeks;

  EntryPageProvider() {
    fillGrades();
  }

  Future<void> fillGrades() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, db.dbname);
    if (await io.File(path).exists()) {
      await _fillGradesFromDB();
    } else {
      if (await connectivity.first == ConnectionStatus.Online) {
        await _fillGradesFromApi();
      }
    }
  }

  void noConnectionSnackBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("Отсутствует подключение к интернету")));
  }

  void refresh(BuildContext context) async {
    await connectivity.first.then(
      (value) async {
        if (value == ConnectionStatus.Online) {
          await _fillGradesFromApi();
        } else {
          noConnectionSnackBar(context);
        }
      },
    );
    _fillGradesFromDB();
  }

  Future<void> _fillGradesFromDB() async {
    grades = [];
    allgroups = [];
    schedules = Map<int, Schedule>();

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
    changeGradeID(grades.first.id);
  }

  Future<void> _fillGradesFromApi() async {
    grades = [];
    allgroups = [];
    schedules = Map<int, Schedule>();
    dbFilled = false;
    grades = await api.getGrades();
    await Future.forEach(
      grades,
      (grade) async {
        var groups = await api.getGroups(grade.id);
        allgroups.add(groups);
      },
    );

    changeGradeID(grades.first.id);

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
    // currentWeek = await api.
    _fillDB();
  }

  Future<void> _fillDB() async {
    await db.refreshDb();
    await db.fillGradeTable(grades);
    await db.fillAllGroupTable(allgroups);
    await db.fillSchedule(schedules);
    dbFilled = true;
    notifyListeners();
  }

  void generateWeeks() async {
    weeks = [];
    var week = Week(schedules[currentGradeID], 'lower', currentGroup.id);
    weeks.add(week);
    week = Week(schedules[currentGradeID], 'upper', currentGroup.id);
    weeks.add(week);
    await db.fillWeeks(weeks);
    weeks = await db.getWeeks(currentGroup.id);
  }

  List<Week> get currentSchedule {
    generateWeeks();
    return weeks;
    //TODO getWeeks и проверку
  }

  void changeGradeID(int newid) {
    currentGradeID = newid;
    var progName = allgroups
        .firstWhere((group) => group.first.gradeid == currentGradeID)
        .first
        .name;
    changeProgName(progName);
  }

  void changeProgName(String progName) {
    currentProgName = progName;
    var group = allgroups
        .firstWhere((grade) => grade.any((gr) => gr.name == currentProgName))
        .first;
    changeGroup(group);
  }

  void changeGroup(Group group) {
    currentGroup = group;
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

  ///Ну ладно
  List<Group> get currentGroups {
    var groups = _groupsOfCurGrade();
    var res = groups.where((group) => group.name == currentProgName);
    return res.toList();
  }

  bool get canNotShowGrades {
    return grades.isEmpty;
  }

  bool get canNotShowGroups {
    return allgroups.isEmpty || allgroups.first.first.id == 0;
  }

  bool get canNotGetSchedule {
    return schedules.isEmpty || !dbFilled;
  }
}
