import 'package:flutter/cupertino.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/schedule/classes/import_classes.dart';

class EntryPageProvider with ChangeNotifier {
  final api = RestClient.create();
  int currentGradeID = 1;
  String currentProgName;
  List<Grade> grades = [];
  List<List<Group>> allgroups = [];

  Future<void> fillGrades() async {
    grades = await api.getGrades();
    grades.forEach(
      (grade) async {
        var groups = await api.getGroups(grade.id);
        allgroups.add(groups);
      },
    );
    notifyListeners();
  }

  void changeGradeID(int newid) {
    currentGradeID = newid;
    notifyListeners();
  }

  void changeProgName(String progName) {
    currentProgName = progName;
    notifyListeners();
  }

  List<Group> _groupOfCurGrade() {
    return allgroups.firstWhere(
        (listOfGroup) => listOfGroup.first.gradeid == currentGradeID);
  }

  Set<String> get currentGroupNames {
    var groups = _groupOfCurGrade();
    var progs = groups.map((group) => group.name.toString()).toSet();
    return progs;
  }

  ///Ну ладно
  List<Group> get currentGroups {
    var groups = _groupOfCurGrade();
    var res = groups.where((group) => group.name == currentProgName);
    return res;
  }

  bool get canShowGrades {
    return grades.isEmpty;
  }

  bool get canShowGroups {
    return allgroups.isEmpty || allgroups.first.first.id == 0;
  }
}
