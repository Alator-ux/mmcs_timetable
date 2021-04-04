import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/lesson.dart';
import 'package:schedule/schedule/classes/week.dart';

class WeekPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeekPageState();
}

class WeekPageState extends State<WeekPage> {
  final week = Week.testConstructor().days;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
            key: PageStorageKey<String>('WeekPageScrollingPosition'),
            itemCount: week.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              return //Theme(
                  // data: ThemeData(
                  //   accentColor: Colors.black,

                  // ),
                  Card(
                // shadowColor: Colors.cyan[100],
                // elevation: 10,
                margin: EdgeInsets.all(10),
                child: ListTileTheme(
                  tileColor: Colors.cyan[50],
                  selectedColor: Colors.black,
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                    key:
                        PageStorageKey<String>('lessonCard' + index.toString()),

                    ///дабы вкладки оставались открытыми
                    title: Text(
                      DaysOfWeek.values[index].asString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),

                    children: week[index].lessons.map((Lesson lesson) {
                      return Container(
                          height: 70,
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                              color: Colors.cyan[50],
                              child: FlatButton(
                                onPressed: () {
                                  showDialog<void>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: Text(lesson.subject),
                                              content: Row(
                                                children: [
                                                  Text("Время: " +
                                                      lesson.time.asString() +
                                                      "\n" +
                                                      "Аудитория: " +
                                                      lesson.room +
                                                      "\n" +
                                                      "Преподаватель: " +
                                                      lesson.teacherName),
                                                ],
                                              ),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('OK'),
                                                ),
                                              ]));
                                },
                                child: Row(children: [
                                  Text(
                                    lesson.time.asString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    lesson.subject,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ]),
                              )));
                    }).toList(),
                  ),
                ),
              );
            }));
  }
}

class LessonInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog();
  }
}
