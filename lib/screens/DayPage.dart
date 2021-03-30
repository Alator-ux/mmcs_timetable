import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/lesson.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'WeekPage.dart';
import 'AppBar.dart';

class DayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: MyAppBar(),
          body: PageView(
            children: [Subjects(), WeekPage()],
          )),
    );
  }
}

class Subjects extends StatelessWidget {
  final List<Lesson> lessons =
      Week.testConstructor().days[DateTime.now().weekday - 1].lessons;
  @override
  Widget build(BuildContext context) {
    return ListView(
      key: PageStorageKey<String>('DayPageScrollingPosition'),
      children: lessons.map((Lesson lesson) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              borderRadius: BorderRadius.circular(15),
            ),
            //color: Colors.cyan[50],
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Column(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(lesson.subject),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lesson.time.beginAsString()),
                                Text('  -  '),
                                Text(lesson.time.endAsString()),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              // margin: EdgeInsets.szymmetric(vertical: 25),
                              width: 1,
                              height: double.infinity,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson.teacherName),
                            Text('Аудитория: ' + lesson.room)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
