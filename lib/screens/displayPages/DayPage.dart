import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/lesson.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'WeekPage.dart';
import '../appBar/AppBar.dart';

class DayPage extends StatelessWidget {
  List<Week> weeks;
  DayPage(this.weeks);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBarHelp(),
        body: ChangeNotifierProvider(
          create: (context) => SubjectProvider.first(weeks),
          child: PageView(
            children: [Subjects(), WeekPage()],
          ),
        ),
        //bottomNavigationBar: , TODO
      ),
    );
  }
}

class Subjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      key: PageStorageKey<String>('DayPageScrollingPosition'),
      children: subjectsInf(context),
    );
  }
}

List<Widget> subjectsInf(BuildContext context) {
  SubjectProvider provider = Provider.of<SubjectProvider>(context);
  Day day = provider.currentDay;
  if (day.isEmpty) {
    return [
      Container(
        child: Text('Сегодня пар нет'),
      ),
    ];
  }
  return day.normalLessons.map((lesson) {
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
              child: Text(lesson.subjectabbr.isEmpty
                  ? lesson.subjectname
                  : lesson.subjectabbr),
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
                        Text(lesson.teachername),
                        Text('Аудитория: ' + lesson.roomname),
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
  }).toList();
}
