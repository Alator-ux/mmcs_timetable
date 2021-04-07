import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';

class WeekPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        key: PageStorageKey<String>('WeekPageScrollingPosition'),
        itemCount: 7,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (BuildContext context, int index) {
          return //Theme(
              // data: ThemeData(
              //   accentColor: Colors.black,

              // ),
              FlatButton(
            onPressed: () {},
            onLongPress: () {},
            child: Card(
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
  Day day = provider.dayByDayID(index);
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
                style: TextStyle(fontSize: 20),
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
        child: Card(
          color: Colors.cyan[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (context) => lessonInfo(context, index, lesson));
              },
              child: Row(children: [
                Text(
                  lesson.time.asString(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 20),
                Text(
                  lesson.subjectabbr.isEmpty
                      ? lesson.subjectname
                      : lesson.subjectabbr,
                  style: TextStyle(fontSize: 17),
                ),
              ]),
            ),
          ),
        ),
      );
    },
  ).toList();
}

AlertDialog lessonInfo(BuildContext context, int ind, NormalLesson lesson) {
  return AlertDialog(
    title: Text(lesson.subjectname),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("Время: " +
                lesson.time.asString() +
                "\n" +
                "Аудитория: " +
                lesson.roomname +
                "\n" +
                "Преподаватель: " +
                "\n" +
                lesson.teachername),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: Text('Изменить'),
              onPressed: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => EditPage(ind, lesson)));
              },
            ),
            FlatButton(
              child: Text('Ок'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    ),
  );
}
