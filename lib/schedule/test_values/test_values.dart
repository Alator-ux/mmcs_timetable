import 'package:flutter/material.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/teacher/teacher.dart';
import 'package:schedule/screens/editPages/editModePage/editProvider.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';

class Pair<FT, ST> {
  final FT first;
  final ST second;

  Pair(this.first, this.second);
}

List<DropdownMenuItem<Grade>> gradeItems(EntryPageProvider provider) {
  if (!provider.canShowGrades) {
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
  if (!provider.canShowGroups) {
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
  if (!provider.canShowGroups) {
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

List<DropdownMenuItem<Teacher>> teacherItems(EntryPageProvider provider) {
  if (!provider.canShowTeachers) {
    return [
      DropdownMenuItem<Teacher>(
        value: Teacher(id: 0, name: ""),
        child: Text('-'),
      )
    ];
  }

  var res = provider.teachers;

  return res.map((Teacher teacher) {
    return DropdownMenuItem<Teacher>(
      value: teacher,
      // child: FittedBox(
      //   fit: BoxFit.fill,
      child: Text(
        teacher.name,
        // textAlign: TextAlign.center,
        // ),
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

List<DropdownMenuItem<Grade>> editPageGradeItems() {
  var editor = EditProvider();
  return editor.grades
      .map(
        (grade) => DropdownMenuItem<Grade>(
          value: grade,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                degreeFromString(grade.degree) +
                    ' ' +
                    grade.n.toString() +
                    ' курс',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      )
      .toList();
}

List<DropdownMenuItem<Group>> editPageGroupItems(Grade curGrade) {
  var editor = EditProvider();
  var groups = editor.allgroups
      .firstWhere((grade) => grade.any((gr) => gr.gradeid == curGrade.id));
  var res = groups
      .map(
        (group) => DropdownMenuItem<Group>(
          value: group,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                group.name + ' группа ' + group.n.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      )
      .toList();
  return res;
}
