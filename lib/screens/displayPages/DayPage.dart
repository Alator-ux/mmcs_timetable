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
  SubjectProvider provider;
  DayPage(this.weeks, this.provider);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider.value(
        value: provider,
        child: DayPageHelper(),
      ),
    );
  }
}

class DayPageHelper extends StatefulWidget {
  @override
  _DayPageHelperState createState() => _DayPageHelperState();
}

class _DayPageHelperState extends State<DayPageHelper> {
  SubjectProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<SubjectProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarHelp(),
      body: PageView(
        children: [Subjects(), WeekPage()],
      ),
      bottomNavigationBar: MyBottomBar(provider.getCurrentWeek()),
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
  double width = MediaQuery.of(context).size.width;
  TextStyle _textStyle = TextStyle(fontSize: width / 25);
  TextStyle _cardTextStyle = TextStyle(fontSize: width / 25);
  SubjectProvider provider = Provider.of<SubjectProvider>(context);
  Day day = provider.currentDay;
  if (day.normalLessons.length == 0) {
    return [
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Сегодня пар нет',
                  style: TextStyle(
                      fontSize: width / 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      )
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
              child: Text(
                lesson.subjectabbr.isEmpty
                    ? lesson.subjectname
                    : lesson.subjectabbr,
                style: _textStyle,
              ),
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
                            Text(
                              lesson.time.beginAsString(),
                              style: _textStyle,
                            ),
                            Text(
                              '  -  ',
                              style: _textStyle,
                            ),
                            Text(
                              lesson.time.endAsString(),
                              style: _textStyle,
                            ),
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
                        Text(lesson.teachername, style: _textStyle),
                        Text('Аудитория: ' + lesson.roomname,
                            style: _textStyle),
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
