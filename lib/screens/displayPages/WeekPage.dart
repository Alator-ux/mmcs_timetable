import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/main.dart';
import 'package:schedule/notifications/notification_service.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/editPages/EditModePage.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';

class WeekPage extends StatelessWidget {
  static const String routeName = '/EntryPage/DayPage/WeekPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        key: PageStorageKey<String>('WeekPageScrollingPosition'),
        itemCount: 7,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (BuildContext context, int index) {
          double width = SizeProvider().width;
          TextStyle _textStyle = TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: width / 20);
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTileTheme(
              tileColor: Colors.cyan[50],
              selectedColor: Colors.black,
              child: GestureDetector(
                onLongPress: () {
                  var settings = SettingsProvider();
                  if (settings.isSaved && !settings.overWrite) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditModePage(index)),
                    );
                  }
                },
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                  key: PageStorageKey<String>('lessonCard' + index.toString()),

                  ///дабы вкладки оставались открытыми
                  title: Container(
                    width: double.infinity,
                    // height: double.infinity,
                    child: Text(
                      DaysOfWeek.values[index].asString(),
                      style: _textStyle,
                    ),
                  ),

                  children: expansionTileItems(context, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<Widget> expansionTileItems(BuildContext context, int index) {
  SubjectProvider provider = Provider.of<SubjectProvider>(context);
  double width = SizeProvider().width;
  TextStyle _textStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: width * 0.04);
  TextStyle _timeTextStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: width * 0.05);
  Day day = provider.dayByDayID(index);
  UserType userType = provider.userType;
  if (day.isEmpty)
    return [
      Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.all(4.0),
        child: Card(
          color: Colors.cyan[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'В этот день у вас пар нет',
                style: _textStyle,
              ),
            ),
          ),
        ),
      ),
    ];
  return day.normalLessons.map(
    (lesson) {
      return Container(
        height: 70,
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            showDialog<void>(
                context: context,
                builder: (context) => lessonInfo(context, userType, lesson));
          },
          child: Card(
            color: Colors.cyan[50],
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Text(
                    lesson.time.asString(),
                    style: _textStyle,
                  ),
                  SizedBox(width: 10),
                  Text(
                    lesson.subjectabbr.isEmpty
                        ? lesson.subjectname
                        : lesson.subjectabbr,
                    style: _textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).toList();
}

AlertDialog lessonInfo(
    BuildContext context, UserType userType, NormalLesson lesson) {
  return AlertDialog(
    title: Text(lesson.subjectname),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Время: " +
              lesson.time.asString() +
              "\n" +
              "Аудитория: " +
              lesson.roomname +
              "\n" +
              (userType == UserType.student
                  ? "Преподаватель: " + "\n" + lesson.teachername
                  : "Группы: " + "\n" + lesson.groupsAsString()),
        ),
      ],
    ),
    actions: [
      TextButton(
        child: Text('Изменить'),
        onPressed: () {
          // Route route = CupertinoPageRoute(
          //     builder: (context) => EditPage(ind, lesson),
          //     settings: RouteSettings(name: "WeekPageAlertDialog"));
          // Navigator.push(context, route);
          var notification = NotificationService();
          var provider = SubjectProvider();
          provider.scheduleAlarms();
          // notification.scheduleAlarm(AlarmInfo(lesson));
        },
      ),
      TextButton(
        child: Text('Ок'),
        onPressed: () {
          var provider = SubjectProvider();
          provider.aaa();
          // Navigator.pop(context);
        },
      ),
    ],
  );
}

/*child: TextButton(
                onPressed: () {},
                onLongPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditModePage(index))),*/
