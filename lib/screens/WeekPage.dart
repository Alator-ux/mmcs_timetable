import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/lesson.dart';
import 'package:schedule/schedule/classes/week.dart';

class WeekPage extends StatefulWidget {
  final List<Week> weeks;
  WeekPage(this.weeks);
  @override
  State<StatefulWidget> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  List<Week> weeks;
  int curWeek = 0;
  _WeekPageState() {
    weeks = widget.weeks;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        key: PageStorageKey<String>('WeekPageScrollingPosition'),
        itemCount: weeks[curWeek].days.length,
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
                key: PageStorageKey<String>('lessonCard' + index.toString()),

                ///дабы вкладки оставались открытыми
                title: Text(
                  DaysOfWeek.values[index].asString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),

                children: expansionTileItems(weeks[curWeek], index),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<Widget> expansionTileItems(Week week, int index) {
  if (week.days[index].isEmpty)
    return [
      Container(
        child: Text('В этот день пар нет'),
      ),
    ];

  return week.days[index].normalLessons.map(
    (lesson) {
      return Container(
        height: 70,
        padding: const EdgeInsets.all(4.0),
        child: Card(
          color: Colors.cyan[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Text(
                lesson.time.asString(),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 20),
              Text(
                lesson.subjectname,
                style: TextStyle(fontSize: 17),
              ),
            ]),
          ),
        ),
      );
    },
  ).toList();
}
