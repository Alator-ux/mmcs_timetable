import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/grade/grade.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/schedule/test_values/test_values.dart';
import 'package:schedule/screens/editPages/editModePage/editProvider.dart';

class ModalBottomSheetController {
  static ModalBottomSheetController _instance;
  List<String> timeAsStrings = ['', '', '', ''];
  String beginH;
  String beginM;
  String endH;
  String endM;

  ModalBottomSheetController._();
  factory ModalBottomSheetController() {
    _instance ??= ModalBottomSheetController._();
    return _instance;
  }
  factory ModalBottomSheetController.init(IntervalOfTime time) {
    var res = ModalBottomSheetController();
    res.beginH = time.beginAsString().substring(0, 2);
    res.timeAsStrings[0] = res.beginH;
    res.beginM = time.beginAsString().substring(3, 5);
    res.timeAsStrings[1] = res.beginM;
    res.endH = time.endAsString().substring(0, 2);
    res.timeAsStrings[2] = res.endH;
    res.endM = time.endAsString().substring(3, 5);
    res.timeAsStrings[3] = res.endM;
    return res;
  }

  IntervalOfTime get time {
    var begin = timeAsStrings[0] + ':' + timeAsStrings[1];
    var end = timeAsStrings[2] + ':' + timeAsStrings[3];
    return IntervalOfTime.fromString(begin, end);
  }

  bool get isIntervalCorrect => areTimesCorrect(time.begin, time.end);
}

class GroupProvider with ChangeNotifier {
  static GroupProvider _instance;
  List<Group> groups = [];
  GroupProvider._();

  Grade curGrade;
  Group curGroup;
  factory GroupProvider() {
    _instance ??= GroupProvider._();
    return _instance;
  }

  factory GroupProvider.init(List<Group> groups) {
    var res = GroupProvider();
    var editor = EditProvider();
    res.curGrade = editor.grades.first;
    res.curGroup = editor.allgroups.first.first;
    if (groups == null) {
      res.groups = [];
    } else {
      res.groups = groups;
    }
    return res;
  }

  changeGrade(Grade newGrade) {
    curGrade = newGrade;
    notifyListeners();
  }

  changeGroup(Group newGroup) {
    curGroup = newGroup;
    notifyListeners();
  }

  bool addGroup() {
    if (_containsGroup()) {
      return false;
    } else {
      groups.add(curGroup);
      return true;
    }
  }

  deleteGroups() {
    groups = [];
  }

  bool _containsGroup() {
    var repeats = groups.where(
      (group) {
        var res = true;
        res = res && group.groupnum == curGroup.groupnum;
        res = res && group.name == curGroup.name;
        res = res && group.gradenum == curGroup.gradenum;
        return res;
      },
    ).toList();
    return repeats.length != 0;
  }
}
