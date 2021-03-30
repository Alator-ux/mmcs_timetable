import 'package:flutter/material.dart';

const List<String> timesForTest = [
  "08:00-09:20",
  "09:50-11:20",
  "11:55-13:30",
  "13:45-15:20",
  "15:45-17:20"
];

List<DropdownMenuItem<String>> courseItems() {
  final courses = getCourses();
  return courses.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}

List<DropdownMenuItem<String>> groupItems() {
  final groups = getGroups();
  return groups.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}

List<DropdownMenuItem<String>> progsItems() {
  final progs = getProgs();
  return progs.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}

List<String> getCourses() {
  final list = List<String>();
  for (int i = 1; i < 6; i++) {
    list.add("Бакалавриат " + i.toString() + " курс");
  }
  for (int i = 1; i < 3; i++) {
    list.add(
      "Магистратура " + i.toString() + " курс",
    );
  }
  for (int i = 1; i < 3; i++) {
    list.add(
      "Аспирантура " + i.toString() + " курс",
    );
  }
  return list;
}

List<String> getProgs() {
  List<String> list = ["ПМИ", "ФИИТ"];
  return list;
}

List<String> getGroups() {
  List<String> list = ["1", "2", "3", "4"];
  return list;
}
