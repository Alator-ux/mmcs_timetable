import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';
import 'package:schedule/screens/widgetsHelper/widgetsHelper.dart';
import 'DDButton.dart';
import 'package:provider/provider.dart';

class EntryPage extends StatefulWidget {
  static const String routeName = '/EntryPage';
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  EntryPageProvider provider;

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EntryPageProvider>(context);
    return Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Radio<UserType>(
              value: UserType.student,
              groupValue: provider.userType,
              onChanged: (value) {
                provider.changeUserType(value);
                if (provider.canShowGrades) {
                  provider.changeGradeID(1);
                }
              },
            ),
            Text(UserType.student.asString()),
            Radio<UserType>(
              value: UserType.teacher,
              groupValue: provider.userType,
              onChanged: (value) {
                provider.changeUserType(value);
                if (provider.canShowTeachers) {
                  provider.changeTeacher(provider.teachers.first);
                }
              },
            ),
            Text(UserType.teacher.asString()),
          ],
        ),
        InformationCard(),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              height: SizeProvider().getSize(0.08, from: SizeFrom.height),
              width: SizeProvider().getSize(0.45),
              child: Text(
                "Зайти в сохраненное",
                style: TextStyle(
                    fontSize: SizeProvider().getSize(0.04),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: SettingsProvider().isSaved
                  ? () async {
                      var settings = SettingsProvider();
                      await settings.initSubjectProvider();
                      var controller = NavigationController();
                      controller.changeScreen(ScreenRoute.displayPage);
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("У вас нет сохраненного расписания"),
                        ),
                      );
                    },
            ),
            nextButton(),
          ],
        ),
      ],
    );
  }

  Widget nextButton() {
    var provider = Provider.of<EntryPageProvider>(context);
    return CustomButton(
      height: SizeProvider().getSize(0.08, from: SizeFrom.height),
      width: SizeProvider().getSize(0.45),
      child: Text(
        "Далее",
        style: TextStyle(
            fontSize: SizeProvider().getSize(0.04),
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      onTap: () async {
        if (!provider.canShowGroups || !provider.isOnline) {
          var settings = SettingsProvider();
          if (!settings.isSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Отсутствует подключение к интернету"),
              ),
            );
          } else {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Отсутствует подключение к интернету"),
                content: Text("Отсутствует подключение к интернету," +
                    '\n' +
                    " однако у вас есть сохраненное расписание." +
                    '\n' +
                    "Желаете ли вы его загрузить?"),
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
                          Navigator.pop(context);
                          var controller = NavigationController();
                          controller.changeScreen(ScreenRoute.displayPage);
                        },
                        child: Text('Да'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        } else {
          var value = await provider.getCurrentSchedule();
          var userType = provider.userType;
          var typeOfWeek = provider.typeOfWeek;
          var grades = provider.grades;
          var groups = provider.allgroups;
          SubjectProvider.create(value, grades, groups, userType, typeOfWeek);
          var controller = NavigationController();
          controller.changeScreen(ScreenRoute.displayPage);
        }
      },
    );
  }
}

class InformationCard extends StatefulWidget {
  const InformationCard();

  @override
  _InformationCardState createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  @override
  Widget build(BuildContext context) {
    var userType = Provider.of<EntryPageProvider>(context).userType;
    var width = SizeProvider().width;
    TextStyle _textStyle =
        TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold);
    return Container(
      width: double.infinity,
      child: Card(
        shadowColor: Colors.cyan[400],
        elevation: 6,
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: userType == UserType.student
              ? studentCard(_textStyle)
              : teacherCard(_textStyle),
        ),
      ),
    );
  }
}

Widget studentCard(TextStyle _textStyle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Курс:", style: _textStyle),
      ButtonTheme(
          alignedDropdown: true, child: FirstDropDownButton(_textStyle)),
      SizedBox(height: 10),
      Text("Направление:", style: _textStyle),
      ButtonTheme(
          alignedDropdown: true, child: SecondDropDownButton(_textStyle)),
      SizedBox(height: 10),
      Text("Группа:", style: _textStyle),
      ButtonTheme(
        alignedDropdown: true,
        child: ThirdDropDowButton(_textStyle),
      ),
      SizedBox(height: 10),
    ],
  );
}

Widget teacherCard(TextStyle _textStyle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Имя", style: _textStyle),
      ButtonTheme(
          alignedDropdown: true, child: TeacherDropDownButton(_textStyle)),
    ],
  );
}
