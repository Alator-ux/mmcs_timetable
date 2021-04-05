import 'package:flutter/cupertino.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/week.dart';

class EntryPageProvider with ChangeNotifier {
  final api = RestClient.create();
  bool dbFilled = true;
  int currentGradeID = 0;
  String currentProgName = '-';
  Group currentGroup = Group(gradeid: 0, id: 0, n: 0, name: '-');
  List<Grade> grades = [];
  List<List<Group>> allgroups = [];
  Map<int, Schedule> schedules = Map<int, Schedule>();
  int currentWeek = 0;

  EntryPageProvider() {
    fillGrades();
  }

  Future<void> fillGrades() async {
    dbFilled = false;
    grades = await api.getGrades();
    await Future.forEach(
      grades,
      (grade) async {
        var groups = await api.getGroups(grade.id);
        allgroups.add(groups);
      },
    );

    currentGradeID = grades.first.id;
    currentProgName = allgroups.first
        .where((group) => group.gradeid == currentGradeID)
        .first
        .name;

    notifyListeners();

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
    fillDB();
  }

  Future<void> fillDB() async {
    //TODO записать в бд
    dbFilled = true;
    notifyListeners();
  }

  List<Week> get currentSchedule {
    List<Week> weeks = [];
    var week = Week(schedules[currentGradeID], 'lower');
    weeks.add(week);
    week = Week(schedules[currentGradeID], 'upper');
    weeks.add(week);
    return weeks;
  }

  void changeGradeID(int newid) {
    currentGradeID = newid;
    var progName = allgroups
        .firstWhere((group) => group.first.gradeid == currentGradeID)
        .first
        .name;
    changeProgName(progName);
    // currentGroup = allgroups
    //     .firstWhere((grade) => grade.first.name == currentProgName)
    //     .first;
    // notifyListeners();
  }

  void changeProgName(String progName) {
    currentProgName = progName;
    var group = allgroups
        .firstWhere((grade) => grade.any((gr) => gr.name == currentProgName))
        .first;
    changeGroup(group);
    // notifyListeners();
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
