import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
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
        AndroidInitializationSettings('ic_white_square');
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

  //Show notification
  void scheduleAlarm(AlarmInfo info) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
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
    );
    // await _flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
    // 'repeating body', RepeatInterval, platformChannelSpecifics,
    // androidAllowWhileIdle: true);
  }

  Future<void> scheduleAlarmList(List<AlarmInfo> infoList) async {
    for (AlarmInfo info in infoList) {
      scheduleAlarm(info);
    }
  }

  void replaceAlarm(AlarmInfo oldInfo, AlarmInfo newInfo) {
    cancel(oldInfo.id);
    scheduleAlarm(newInfo);
  }

  void replaceAlarmList(
      List<AlarmInfo> oldInfoList, List<AlarmInfo> newInfoList) {
    for (AlarmInfo oldInfo in oldInfoList) {
      cancel(oldInfo.id);
    }
    for (AlarmInfo newInfo in newInfoList) {
      scheduleAlarm(newInfo);
    }
  }

  void cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAll() async {
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
    var dateTime = DateTime.now().add(Duration(seconds: 1));
    time = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );
    id = lesson.lessonid;
    title = 'Скоро пара! В ${lesson.time.beginAsString()}';
    body = lesson.subjectname.isEmpty ? lesson.subjectabbr : lesson.subjectname;
  }
}
