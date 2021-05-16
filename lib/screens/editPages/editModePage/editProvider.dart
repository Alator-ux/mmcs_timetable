import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/grade/grade.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';

class EditProvider with ChangeNotifier {
  static EditProvider _instance;
  SubjectProvider _subjectProvider = SubjectProvider();
  List<NormalLesson> _tempLessons = [];
  int _dayId;
  TypeOfWeek _selectedWeek;
  UserType _userTyper;
  List<Grade> grades;
  List<List<Group>> allgroups;
  int nowEditing;
  EditProvider._();
  factory EditProvider() {
    _instance ??= EditProvider._();
    return _instance;
  }
  factory EditProvider.init(dayId) {
    var res = EditProvider();
    res._dayId = dayId;
    res._selectedWeek = res._subjectProvider.selectedWeek;
    var weekInd = res._selectedWeek.index;
    var tLessons =
        res._subjectProvider.weeks[weekInd].days[dayId].normalLessons;
    res._tempLessons = List.generate(
      tLessons.length,
      (ind) => NormalLesson.copy(tLessons[ind]),
    );
    res._userTyper = res._subjectProvider.userType;
    res.grades = res._subjectProvider.grades;
    res.allgroups = res._subjectProvider.allGroups;
    res.nowEditing = 0;
    return res;
  }

  int get dayId => _dayId;
  List<NormalLesson> get lessons => _tempLessons;
  TypeOfWeek get selectedWeek => _selectedWeek;
  UserType get userType => _userTyper;
  bool get canAdd => _tempLessons.length < 10;

  void deleteLesson(NormalLesson lesson) {
    var isrem = _tempLessons.remove(lesson);
    print(isrem);
    notifyListeners();
  }

  void newLesson(NormalLesson newLesson) {
    if (newLesson.lessonid == 0) {
      newLesson.lessonid = _generateID();
    } else {
      var ind = _tempLessons
          .indexWhere((lesson) => lesson.lessonid == newLesson.lessonid);
      _tempLessons.removeAt(ind);
    }
    if (userType == UserType.teacher) {
      newLesson.uberid = _generateUberID();
      newLesson.groups.forEach(
        (group) {
          group.uberid = newLesson.uberid;
        },
      );
      newLesson.groups.sort((gr1, gr2) => Group.compareGroups(gr1, gr2));
    }
    _tempLessons.add(newLesson);
    _tempLessons.sort((l1, l2) => IntervalOfTime.compare(l1.time, l2.time));
    notifyListeners();
  }

  /// Save temp lessons as main lessons in selected day and week
  Future<void> save() async {
    _subjectProvider.save(dayId: dayId, lessons: _tempLessons);
  }

  int _generateID() {
    Random random = new Random();
    var weeks = _subjectProvider.weeks;
    int generatedID;
    do {
      generatedID = random.nextInt(1000) + 10000;
      //до тех пор пока в каждой недели нет хотя бы одного урока такого айди
    } while (weeks.any((week) => week.days.any((day) =>
        day.normalLessons.any((lesson) => (lesson.lessonid) == generatedID))));
    return generatedID;
  }

  int _generateUberID() {
    Random random = new Random();
    var weeks = _subjectProvider.weeks;
    int generatedID;
    do {
      generatedID = random.nextInt(1000) + 1000;
      //до тех пор пока в каждой недели нет хотя бы одного урока такого айди
    } while (weeks.any((week) => week.days.any((day) =>
        day.normalLessons.any((lesson) => (lesson.uberid) == generatedID))));
    return generatedID;
  }

  bool isCrossed(IntervalOfTime time) {
    for (var i = 0; i < nowEditing; i++) {
      if (time.isCrossed(_tempLessons[i].time)) {
        return true;
      }
    }
    for (var i = nowEditing + 1; i < _tempLessons.length; i++) {
      if (time.isCrossed(_tempLessons[i].time)) {
        return true;
      }
    }
    return false;
  }
}
