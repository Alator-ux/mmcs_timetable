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
            itemCount: week.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return Theme(
                data: ThemeData(
                  accentColor: Colors.black,
                ),
                child: ExpansionTile(
                  title: Text(
                    DaysOfWeek.values[index].asString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  children: week[index].lessons.map((Lesson lesson) {
                    return Container(
                      height: 70,
                      child: Card(
                        child: Container(
                          color: Colors.cyan[50],
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
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }));
  }
}
