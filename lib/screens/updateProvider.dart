import 'package:flutter/material.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/connectivity/connectivity_service.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/schedule/schedule.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';

class UpdateProvider with ChangeNotifier {
  static UpdateProvider _instance;
  bool needToUpdate = false;
  List<Week> apiWeeks;
  TypeOfWeek _typeOfWeek;
  final _api = RestClient.create();
  final _connectivity = ConnectivityService();
  DBProvider _db = DBProvider.db;
  SettingsProvider _settings = SettingsProvider();
  bool _isOnline = false;

  UpdateProvider._() {
    compareSchedule();
  }
  factory UpdateProvider() {
    _instance ??= UpdateProvider._();
    return _instance;
  }

  void compareSchedule() async {
    if (_settings.isSaved) {
      var status = await _connectivity.currentStatus;
      _isOnline = status == ConnectionStatus.Online;
    } else {
      needToUpdate = false;
      return;
    }
    if (!_isOnline) {
      return;
    }

    var userType = _settings.userType;
    var id = _settings.id;
    var savedTypeOfWeek = _settings.calculateCurrentWeek();
    Schedule schedule;
    List<Week> weeks = [];
    if (userType == UserType.student) {
      schedule = await _api.getSchedule(id);
      weeks = await _db.getWeeksForStudent(0);
    } else {
      schedule = await _api.getScheduleOfTeacher(id);
      weeks = await _db.getWeeksForTeacher(0);
    }

    var apiGrades = await _api.getGrades();
    List<int> apiGradeid = [];
    await Future.forEach(
      apiGrades,
      (grade) {
        apiGradeid.add(grade.id);
      },
    );
    List<List<Group>> apiAllGroups = [];
    await Future.forEach(
      apiGrades,
      (grade) async {
        var groups = await _api.getGroups(grade.id);
        groups.forEach(
          (group) {
            group.degree = grade.degree;
            group.gradenum = grade.n;
            group.groupnum = group.n;
          },
        );
        apiAllGroups.add(groups);
      },
    );

    var grades = await _db.getAllGrades();
    List<int> gradeid = [];
    await Future.forEach(
      grades,
      (grade) {
        gradeid.add(grade.id);
      },
    );
    var allGroups = await _db.getAllGroups(gradeid);

    if (apiGradeid.length != gradeid.length) {
      await _db.refreshGrades(apiGrades);
    } else {
      for (int i = 0; i < gradeid.length; i++) {
        if (apiGradeid[i] != gradeid[i]) {
          await _db.refreshGrades(apiGrades);
          break;
        }
      }
    }
    if (apiAllGroups.length != allGroups.length) {
      await _db.refreshAllGroups(apiAllGroups);
    } else {
      for (int i = 0; i < allGroups.length; i++) {
        var flag = false;
        if (apiAllGroups[i].length != allGroups[i].length) {
          await _db.refreshAllGroups(apiAllGroups);
          break;
        }
        for (int j = 0; j < allGroups[i].length; j++) {
          if (!apiAllGroups[i][j].isEqual(allGroups[i][j])) {
            await _db.refreshAllGroups(apiAllGroups);
            flag = true;
            break;
          }
        }
        if (flag) {
          break;
        }
      }
    }

    var tweekInd = await _api.getCurrentWeek();
    _typeOfWeek = TypeOfWeek.values[tweekInd];

    List<Week> apiWeeks = [];
    var _apiWeek = Week(schedule, TypeOfWeek.lower);
    apiWeeks.add(_apiWeek);
    _apiWeek = Week(schedule, TypeOfWeek.upper);
    apiWeeks.add(_apiWeek);
    if (!weeks[0].isEqual(apiWeeks[0])) {
      needToUpdate = true;
    } else if (!weeks[1].isEqual(apiWeeks[1])) {
      needToUpdate = true;
    }
    // } else if (savedTypeOfWeek != _typeOfWeek) {

    // }

    notifyListeners();
  }

  void changeNeedToUpdate(bool flag) {
    needToUpdate = flag;
    notifyListeners();
  }
}
