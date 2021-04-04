import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/import_classes.dart';

const List<String> timesForTest = [
  "08:00-09:20",
  "09:50-11:20",
  "11:55-13:30",
  "13:45-15:20",
  "15:45-17:20"
];

class Pair<FT, ST> {
  final FT first;
  final ST second;

  Pair(this.first, this.second);
}

List<DropdownMenuItem<Grade>> gradeItems(List<Grade> grades) {
  if (grades.length == 0) {
    return [
      DropdownMenuItem<Grade>(
        value: Grade(id: 0, n: 0, degree: '-'),
        child: Text('-'),
      )
    ];
  }

  return grades.map((Grade grade) {
    return DropdownMenuItem<Grade>(
      value: grade,
      child: Text(
          degreeFromString(grade.degree) + ' ' + grade.n.toString() + ' курс'),
    );
  }).toList();
}

List<DropdownMenuItem<String>> progItems(
    List<List<Group>> allGroups, int gradeID) {
  if (allGroups.length == 0 || allGroups.first.first.id == 0) {
    return [
      DropdownMenuItem<String>(
        value: '0',
        child: Text('-'),
      )
    ];
  }

  var groups = allGroups
      .firstWhere((listOfGroup) => listOfGroup.first.gradeid == gradeID);
  var progs = groups.map((group) => group.name.toString()).toSet();
  // print('groups len ' + groups.length.toString());

  return progs.map((name) {
    return DropdownMenuItem<String>(
      value: name,
      child: Text(name.trim()),
    );
  }).toList();
}

List<DropdownMenuItem<Group>> groupItems(
    List<List<Group>> allGroups, int gradeID, String progName) {
  if (allGroups.length == 0 || allGroups.first.first.id == 0) {
    return [
      DropdownMenuItem<Group>(
        value: Group(id: 0, n: 0, gradeid: 0, name: '-'),
        child: Text('-'),
      )
    ];
  }

  var groups = allGroups
      .firstWhere((listOfGroup) => listOfGroup.first.gradeid == gradeID);
  // print('groups len ' + groups.length.toString());
  // print(progName);
  var res = groups.where((group) => group.name == progName);
  // print('res len ' + res.length.toString());
  return res.map((Group group) {
    return DropdownMenuItem<Group>(
      value: group,
      child: Text(group.n.toString()),
    );
  }).toList();
}

String degreeFromString(String degree) {
  if (degree == 'bachelor') {
    return 'Бакалавриат';
  } else if (degree == 'master') {
    return "Магистратура";
  } else if (degree == 'postgraduate') return "Аспирантура";
  return ' ';
}

// int idFromDegree(String)

// List<String> getgrades() {
//   final list = List<String>();
//   for (int i = 1; i < 6; i++) {
//     list.add("Бакалавриат " + i.toString() + " курс");
//   }
//   for (int i = 1; i < 3; i++) {
//     list.add(
//       "Магистратура " + i.toString() + " курс",
//     );
//   }
//   for (int i = 1; i < 3; i++) {
//     list.add(
//       "Аспирантура " + i.toString() + " курс",
//     );
//   }
//   return list;
// }

// List<String> getProgs() {
//   List<String> list = ["1", "2", "3"];
//   return list;
// }

// List<String> getGroups() {
//   List<String> list = ["1", "2", "3", "4"];
//   return list;
// }
