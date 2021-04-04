import 'package:flutter/cupertino.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'EntryPageProvider.dart';

class EntryPageProvider with ChangeNotifier {
  final api = RestClient.create();
  int currentGradeID = 0;
  String currentProgName = '-';
  Group currentGroup = Group(gradeid: 0, id: 0, n: 0, name: '-');
  List<Grade> grades = [];
  List<List<Group>> allgroups = [];

  EntryPageProvider() {
    fillGrades();
  }

  Future<void> fillGrades() async {
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
    notifyListeners();
  }

  void changeProgName(String progName) {
    currentProgName = progName;
    currentGroup = allgroups
        .firstWhere((grade) => grade.any((gr) => gr.name == currentProgName))
        .first;
    notifyListeners();
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
}
