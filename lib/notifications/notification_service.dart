import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const MethodChannel platform = MethodChannel('schedule.dev/flutter_schedule');

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload;

  static NotificationService _instance;

  NotificationService._();

  factory NotificationService() {
    _instance ??= NotificationService._();
    return _instance;
  }

  Future<String> getInitialRoute() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    String initialRoute = MainPage.routeName;
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      selectedNotificationPayload = notificationAppLaunchDetails.payload;
      initialRoute = DayPage.routeName;
    }

    return initialRoute;
  }

  /// Set notification settings for android and ios platforms
  /// and configure local timezone
  Future<void> configureNotifications() async {
    _configureInitializationSettings();
    _configureLocalTimeZone();
  }

  ///Notification settings for android and ios platforms
  Future<void> _configureInitializationSettings() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_onesignal_default');
    // final initializationSettingsIOS = IOSInitializationSettings(
    //     requestAlertPermission: true,
    //     requestBadgePermission: true,
    //     requestSoundPermission: false,
    //     onDidReceiveLocalNotification:
    //         (int id, String title, String body, String payload) async {});
    final initializationSettingsIOS = IOSInitializationSettings();

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {});
  }

  ///Configure local timezone...
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;
    final locationName = tz.getLocation('Europe/Moscow');
    // tz.getLocation(locations.keys.first); //TODO сделать нормальную локаль
    tz.setLocalLocation(locationName);
  }

  Future<List<PendingNotificationRequest>> getNotifs() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  //Show notification
  Future<void> scheduleAlarm(AlarmInfo info) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
    );

    // var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    //     // sound: 'a_long_cold_sting.wav',
    //     presentAlert: true,
    //     presentBadge: true,
    //     presentSound: true);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      info.id,
      info.title,
      info.body,
      info.time,
      platformChannelSpecifics,
      // androidAllowWhileIdle used to determine if the notification should be delivered at the specified time
      // even when the device in a low-power idle mode
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: info.time.toString(),
    );
  }

  Future<void> scheduleAlarmList(List<AlarmInfo> infoList) async {
    await cancelAll();
    for (AlarmInfo info in infoList) {
      await scheduleAlarm(info);
    }
  }

  void replaceAlarm(AlarmInfo oldInfo, AlarmInfo newInfo) {
    cancel(oldInfo.id);
    scheduleAlarm(newInfo);
  }

  void replaceAlarmList(
      List<AlarmInfo> oldInfoList, List<AlarmInfo> newInfoList) {
    cancelAll();
    for (AlarmInfo newInfo in newInfoList) {
      scheduleAlarm(newInfo);
    }
  }

  void cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

class AlarmInfo {
  int id;
  String title;
  String body;
  tz.TZDateTime time;

  AlarmInfo(NormalLesson lesson) {
    // var time = Time(18,0,0);
    var dateTime = DateTime.now().add(Duration(seconds: 10));
    print(dateTime);
    time = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );
    id = lesson.lessonid;
    title = 'Скоро пара! В ${lesson.time.beginAsString()}';
    body = lesson.subjectname.isEmpty ? lesson.subjectabbr : lesson.subjectname;
  }

  AlarmInfo.withDateTime(NormalLesson lesson, DateTime dateTime) {
    time = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );
    id = lesson.lessonid + dateTime.day;
    title = 'Скоро пара! В ${lesson.time.beginAsString()}';
    body = lesson.subjectname.isEmpty ? lesson.subjectabbr : lesson.subjectname;
  }

  static List<AlarmInfo> _alarmsFromList(
      List<NormalLesson> lessons, int weekNumber) {
    List<AlarmInfo> res = [];
    TimeOfDay pushNotifTime = SettingsProvider().pushNotifTime;
    var dateTime = DateTime.now();
    var year = dateTime.year;
    var month = dateTime.month;
    var day = dateTime.day;
    var weekDay = dateTime.weekday - 1;
    for (var lesson in lessons) {
      //TODO вынести из цикла
      var dif = lesson.dayid - weekDay;

      var dayTime = lesson.time.begin;
      var hour = dayTime.hour;
      var minute = dayTime.minute - pushNotifTime.minute;
      var daysToAdd = dif + 7 * weekNumber;
      // var daysInCurMonth = DateTime(year, month + 1, 0).day;
      // if (daysToAdd > daysInCurMonth) {
      //   daysToAdd -= daysInCurMonth;
      //   if (month != 12) {
      //     month += 1;
      //   } else {
      //     month = 1;
      //     year += 1;
      //   }
      // }
      var newDateTime = DateTime(year, month, day, hour, minute);
      newDateTime = newDateTime.add(Duration(days: daysToAdd));

      res.add(AlarmInfo.withDateTime(lesson, newDateTime));
    }
    return res;
  }

  static List<AlarmInfo> alarmsFromList(List<Week> weeks, int startWeekInd) {
    List<AlarmInfo> res = [];
    TimeOfDay pushNotifTime = SettingsProvider().pushNotifTime;
    var dateTime =
        DateTime.now().add(Duration(minutes: -1 * pushNotifTime.minute));
    var curWeekDay = dateTime.weekday - 1;

    // var test = weeks[startWeekInd].days[curWeekDay].normalLessons.first;
    // var now = DateTime.now();
    // var atest = AlarmInfo.withDateTime(test, now.add(Duration(seconds: 2)));
    // res.add(atest);
    var lessons = weeks[startWeekInd]
        .days[curWeekDay]
        .normalLessons
        .where((lesson) => IntervalOfTime.compareTimeOfDay(
            lesson.time.begin, IntervalOfTime.timeOfDayFromDateTime(dateTime)))
        .toList();
    res.addAll(_alarmsFromList(lessons, 0));

    for (var dayInd = curWeekDay + 1; dayInd < 7; dayInd++) {
      var lessons = weeks[startWeekInd].days[dayInd].normalLessons;
      res.addAll(_alarmsFromList(lessons, 0));
    }
    for (var weekNumber = 1; weekNumber < 4; weekNumber++) {
      var weekInd = (startWeekInd + weekNumber) % 2;
      for (var day in weeks[weekInd].days) {
        var lessons = day.normalLessons;
        res.addAll(_alarmsFromList(lessons, weekNumber));
      }
    }

    // for (var dayInd = 0; dayInd <= curWeekDay; dayInd++) {
    //   var lessons = weeks[(startWeekInd + 1) % 2].days[dayInd].normalLessons;
    //   res.addAll(_alarmsFromList(lessons, 3));
    // }

    return res;
  }
}
