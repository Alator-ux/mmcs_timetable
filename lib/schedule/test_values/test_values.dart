import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';

class Pair<FT, ST> {
  final FT first;
  final ST second;

  Pair(this.first, this.second);
}

List<DropdownMenuItem<Grade>> gradeItems(EntryPageProvider provider) {
  if (provider.canNotShowGrades) {
    return [
      DropdownMenuItem<Grade>(
        value: Grade(id: 0, n: 0, degree: '-'),
        child: Text('-'),
      )
    ];
  }

  List<Grade> grades = provider.grades;

  return grades.map((Grade grade) {
    return DropdownMenuItem<Grade>(
      value: grade,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Text(
          degreeFromString(grade.degree) + ' ' + grade.n.toString() + ' курс',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }).toList();
}

List<DropdownMenuItem<String>> progItems(EntryPageProvider provider) {
  if (provider.canNotShowGroups) {
    return [
      DropdownMenuItem<String>(
        value: '0',
        child: Text('-'),
      )
    ];
  }

  var progs = provider.currentGroupNames;

  return progs.map((name) {
    return DropdownMenuItem<String>(
      value: name,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Text(
          name,
          textAlign: TextAlign.center,
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }).toList();
}

List<DropdownMenuItem<Group>> groupItems(EntryPageProvider provider) {
  if (provider.canNotShowGroups) {
    return [
      DropdownMenuItem<Group>(
        value: Group(id: 0, n: 0, gradeid: 0, name: '-'),
        child: Text('-'),
      )
    ];
  }

  var res = provider.currentGroups;

  return res.map((Group group) {
    return DropdownMenuItem<Group>(
      value: group,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Text(
          group.n.toString(),
          // textAlign: TextAlign.center,
        ),
      ),
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
