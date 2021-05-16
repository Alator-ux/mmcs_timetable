import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final DBProvider _db = DBProvider.db;
  static SettingsProvider _instance;
  Future<SharedPreferences> _prefs;
  SubjectProvider _subjectProvider = SubjectProvider();
  EntryPageProvider _entryPageProvider = EntryPageProvider();
  bool pushOn;
  TimeOfDay pushNotifTime;
  TypeOfWeek _startTypeOfWeek;
  bool isSaved;
  bool overWrite;
  DateTime _timeWhenSaved;
  UserType userType;
  int id;

  SettingsProvider._();
  factory SettingsProvider() {
    _instance ??= SettingsProvider._();
    _instance._prefs ??= SharedPreferences.getInstance();
    return _instance;
  }

  ///Initialize settings provider from shared preference
  Future<void> init() async {
    final SharedPreferences prefs = await _prefs;

    var tempIsSaved = prefs.getBool('isSaved');
    isSaved = tempIsSaved == null ? false : tempIsSaved;

    var tempPushNotifTime = prefs.getInt('pushNotifTime');
    pushNotifTime = tempPushNotifTime == null
        ? TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay(hour: 0, minute: tempPushNotifTime);

    var tempWeekInd = prefs.getInt('weekInd');
    var startWeekInd = tempWeekInd == null ? 0 : tempWeekInd;
    _startTypeOfWeek = TypeOfWeek.values[startWeekInd];

    var temppushOn = prefs.getBool('notifOn');
    pushOn = temppushOn == null ? false : temppushOn;

    var tempTimeWhenSaved = prefs.getInt('timeWhenSaved');
    _timeWhenSaved = tempTimeWhenSaved == null
        ? _weekBegin()
        : DateTime.fromMillisecondsSinceEpoch(tempTimeWhenSaved);

    var tempUserTypeInd = prefs.getInt('userTypeInd');
    var userTypeInd = tempUserTypeInd == null ? 0 : tempUserTypeInd;
    userType = UserType.values[userTypeInd];

    var tempid = prefs.getInt('id');
    id = tempid == null ? 0 : tempid;

    overWrite = false;
    await initSubjectProvider();
  }

  Future<void> initSubjectProvider() async {
    if (isSaved) {
      overWrite = false;
      await _subjectProvider.initFromDB(userType, calculateCurrentWeek());
    }
  }

  ///Set UserType, TypeOfWeek and id
  void setUTandToW({UserType userType, TypeOfWeek typeOfWeek, int newId}) {
    if (!isSaved) {
      userType = userType;
      _startTypeOfWeek = typeOfWeek;
      id = newId;
    }
  }

  ///Calculate current type of the current week
  TypeOfWeek calculateCurrentWeek() {
    var beginOfCurWeek = _weekBegin();
    //Теперь dif имеет вид 7*k, где k может быть равно от 0 до очень больших чисел.
    var dif = _timeWhenSaved.difference(beginOfCurWeek).inDays;
    //Теперь dif имеет вид k, где k может быть либо четным, либо нет.
    dif = (dif / 7).round();
    //Узнаем четность
    var parity = dif % 2;
    //Если dif четное, то прошло 2*m недели (включая начальную) и теперь тип недели такой же какой был в начале
    //Если нечетный, то прошла 2*m+1 неделя (включая начальную) и теперь тип недели отличается от начального
    return TypeOfWeek.values[(parity + _startTypeOfWeek.index) % 2];
  }

  ///Save settings in shared preference
  Future<void> save() async {
    if (overWrite) {
      await _overWriteSavePart();
    }
    overWrite = false;
    isSaved = true;
    userType = _subjectProvider.userType;
    _startTypeOfWeek = _subjectProvider.currentWeek;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifOn', pushOn);
    prefs.setInt('pushNotifTime', pushNotifTime.minute);
    prefs.setBool('isSaved', isSaved);
    var timeWhenSaved = _weekBegin().millisecondsSinceEpoch;
    prefs.setInt('timeWhenSaved', timeWhenSaved);
    prefs.setInt('weekInd', _subjectProvider.currentWeek.index);
    prefs.setInt('userTypeInd', userType.index);
    prefs.setInt('id', id);
    notifyListeners();
  }

  Future<void> _overWriteSavePart() async {
    await _db.refreshDb();
    await _db.fillWeeks(_subjectProvider.weeks);
    pushOn = false;
    pushNotifTime = TimeOfDay(hour: 0, minute: 0);

    await _db.refreshGrades(_entryPageProvider.grades);
    await _db.refreshAllGroups(_entryPageProvider.allgroups);
    userType = _entryPageProvider.userType;
    _startTypeOfWeek = _entryPageProvider.typeOfWeek;
    if (userType == UserType.student) {
      id = _entryPageProvider.currentGroup.id;
    } else {
      id = _entryPageProvider.currentTeacher.id;
    }
  }

  ///Returns date of begin of the current week
  DateTime _weekBegin() {
    var now = DateTime.now();
    var year = now.year;
    var month = now.month;
    var day = now.day - now.weekday - 1; //день на начало недели
    var weekBegin = DateTime(year, month, day);
    return weekBegin;
  }

  ///Set time before a lesson for trigger push-notification
  Future<void> changePushNotifTime(TimeOfDay newTime) async {
    pushNotifTime = newTime;
    _subjectProvider.scheduleAlarms();
    await save();
  }

  Future<void> notificationsOn() async {
    _subjectProvider.scheduleAlarms();
    pushOn = true;
    await save();
  }

  Future<void> notificationsOff() async {
    _subjectProvider.cancelAlarms();
    pushOn = false;
    pushNotifTime = _pushNotifTimes.first.value;
    await save();
  }

  Future<void> refreshSchedule() async {
    await _subjectProvider.refreshFromDB();
  }

  ///Returns List of DropdownMenuItems for notificationTimeController
  List<DropdownMenuItem> get pushNotifTimeDDMItems => _pushNotifTimes;
}

final List<DropdownMenuItem> _pushNotifTimes = [
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 0),
    child: Text('0 мин'),
  ),
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 5),
    child: Text('5 мин'),
  ),
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 10),
    child: Text('10 мин'),
  ),
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 15),
    child: Text('15 мин'),
  ),
];
