import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/day.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/updateProvider.dart';
import 'WeekPage.dart';
import '../appBar/AppBar.dart';

class DayPage extends StatelessWidget {
  static const String routeName = '/EntryPage/DayPage';
  @override
  Widget build(BuildContext context) {
    return ProviderInit();
  }
}

class ProviderInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SubjectProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UpdateProvider(),
        ),
      ],
      child: DayPageHelper(),
    );
  }
}

class DayPageHelper extends StatefulWidget {
  @override
  _DayPageHelperState createState() => _DayPageHelperState();
}

class _DayPageHelperState extends State<DayPageHelper> {
  SubjectProvider provider;
  UpdateProvider updProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<SubjectProvider>(context);
    updProvider = Provider.of<UpdateProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarHelp(),
      body: Builder(builder: (context) {
        return PageView(
          children: [Subjects(), WeekPage()], //TODO builder
        );
      }),
      bottomNavigationBar: MyBottomBar(
        currentWeek: provider.currentWeek,
        selectedWeek: provider.selectedWeek,
      ),
    );
  }
}

class Subjects extends StatelessWidget {
  static const String routeName = '/EntryPage/DayPage/Subjects';
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        var updProvider = UpdateProvider();
        var provider = SubjectProvider();
        if (updProvider.needToUpdate) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Доступно обновленное расписание'),
              content: Text(
                  'Появилась новая версия выбранного расписания. Хотите ли вы его обновить? При обновлении текущее будет стерто.'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Нет'),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.refresh(updProvider.apiWeeks,
                            provider.userType, provider.currentWeek);
                      },
                      child: Text('Да'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
    return ListView(
      key: PageStorageKey<String>('DayPageScrollingPosition'),
      children: subjectsInf(context),
    );
  }
}

List<Widget> subjectsInf(BuildContext context) {
  SubjectProvider provider = Provider.of<SubjectProvider>(context);
  double width = SizeProvider().width;
  TextStyle _cardTextStyle = TextStyle(fontSize: width * 0.04);
  TextStyle _textStyle = TextStyle(fontSize: width * 0.04);
  var userType = provider.userType;
  Day day = provider.currentDay;
  if (day.isEmpty) {
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
                        Text(
                            userType == UserType.student
                                ? lesson.teachername
                                : lesson.groupsAsString(),
                            style: _textStyle),
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
