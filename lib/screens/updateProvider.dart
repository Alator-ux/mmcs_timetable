import 'package:flutter/material.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/connectivity/connectivity_service.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/schedule/schedule.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';

class UpdateProvider with ChangeNotifier {
  static UpdateProvider _instance;
  bool needToUpdate = false;
  List<Week> apiWeeks;
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
    }
    if (!_isOnline) {
      return;
    }

    var userType = _settings.userType;
    var id = _settings.id;
    Schedule schedule;
    List<Week> weeks = [];
    if (userType == UserType.student) {
      schedule = await _api.getSchedule(id);
      weeks = await _db.getWeeksForStudent(0);
    } else {
      schedule = await _api.getScheduleOfTeacher(id);
      weeks = await _db.getWeeksForTeacher(0);
    }
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
    notifyListeners();
  }
}
