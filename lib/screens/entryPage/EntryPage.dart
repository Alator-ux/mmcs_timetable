import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schedule/main.dart';
import 'package:schedule/notifications/notification_service.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
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
    // double width = MediaQuery.of(context).size.width;
    // TextStyle _textStyle = TextStyle(fontSize: width / 25);
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
              },
            ),
            Text(UserType.student.asString()),
            Radio<UserType>(
              value: UserType.teacher,
              groupValue: provider.userType,
              onChanged: (value) {
                provider.changeUserType(value);
              },
            ),
            Text(UserType.teacher.asString()),
          ],
        ),
        InformationCard(),
        SizedBox(height: 20),
        nextButton(context),
        ElevatedButton(
          // color: Colors.grey[200],
          child: Text(
            "Обновить",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: provider.isOnline
              ? () {
                  if (provider.dbFilled) {
                    //TODO snackbar
                    provider.refresh(context);
                  }
                  // var notification = NotificationService();
                  // notification.scheduleAlarm(DateTime.now().hashCode);
                }
              : null,
        ),
      ],
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

Widget nextButton(BuildContext context) {
  var provider = Provider.of<EntryPageProvider>(context);
  return ElevatedButton(
    // color: Colors.grey[200],
    child: Text(
      "Далее",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    onPressed: () async {
      if (!provider.canShowGroups || !provider.dbFilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Пожалуйста, подождите пару секунд"),
          ),
        );
      } else {
        var value = await provider.getCurrentSchedule();
        SubjectProvider.create(value);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DayPage(),
            settings: RouteSettings(name: DayPage.routeName),
          ),
        );
      }
    },
  );
}
