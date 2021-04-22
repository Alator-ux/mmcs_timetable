import 'package:flutter/material.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/week.dart';

class EditProvider with ChangeNotifier {
  final DBProvider db = DBProvider.db;

  EditProvider();

  void changeLesson(NormalLesson lesson) {
    db.changeNormalLesson(lesson);
  }
}
