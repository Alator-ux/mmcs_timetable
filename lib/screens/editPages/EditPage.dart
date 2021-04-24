import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/database/gerard-benedict.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import '../appBar/AppBar.dart';

class EditPage extends StatelessWidget {
  int dayID;
  NormalLesson lesson;
  EditPage(this.dayID, this.lesson);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: EditPageAppBar(),
        body: EditColumn(dayID, lesson),
      ),
    );
  }
}

class EditColumn extends StatelessWidget {
  TextEditingController firstController = TextEditingController();
  final InputDecoration formDecoration = textFormDecoration();
  final BoxDecoration containerDecoration = wrapperDecoration();
  NormalLesson lesson;
  int dayID;
  EditColumn(this.dayID, this.lesson);
  @override
  Widget build(BuildContext context) {
    // SubjectProvider provider = Provider.of<SubjectProvider>(context);
    // provider.;
    // var provider = SubjectProvider();
    // NormalLesson lesson =
    DBProvider db = DBProvider.db;
    double width = MediaQuery.of(context).size.width;
    TextStyle titleTextStyle = titleTStyle(width);
    TextStyle formTextStyle = formTStyle(width);
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      children: [
        Center(
          child: Text(
            'Название предмета',
            style: titleTextStyle,
          ),
        ),
        Container(
          decoration: containerDecoration,
          child: TextFormField(
            textAlign: TextAlign.center,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value.isEmpty) return "Пожалуйста, заполните это поле!";
              if (value.length > 50) return "Пожалуйста, сократите назвавание";
              return "";
            },
            decoration: formDecoration,
            keyboardType: TextInputType.name,
            initialValue: lesson.subjectname,
            style: formTextStyle,
            onFieldSubmitted: (String value) {
              // lesson.subjectname = value;
            },
          ),
        ),
        Box(),
        Center(
          child: Column(
            children: [
              Text(
                'Аббревиатура',
                style: titleTextStyle,
              ),
              Text(
                '(это поле можете оставить пустым)',
                style: titleTextStyle,
              ),
            ],
          ),
        ),
        Container(
          decoration: containerDecoration,
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: formDecoration,
            keyboardType: TextInputType.name,
            initialValue: lesson.subjectabbr,
            style: formTextStyle,
            onFieldSubmitted: (String value) {
              lesson.subjectabbr = value;
            },
          ),
        ),
        Box(),
        Center(
          child: Column(
            children: [
              Text(
                'Имя преподавателя',
                style: titleTextStyle,
              ),
              Text(
                '(это поле можете оставить пустым)',
                style: titleTextStyle,
              ),
            ],
          ),
        ),
        Container(
          decoration: containerDecoration,
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: formDecoration,
            keyboardType: TextInputType.name,
            initialValue: lesson.teachername,
            style: formTextStyle,
            onFieldSubmitted: (String value) {
              lesson.teachername = value;
            },
          ),
        ),
        Box(),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Аудитория',
                style: titleTextStyle,
              ),
              Text(
                '(это поле можете оставить пустым)',
                style: titleTextStyle,
              ),
            ],
          ),
        ),
        Container(
          decoration: containerDecoration,
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: formDecoration,
            keyboardType: TextInputType.name,
            initialValue: lesson.roomname,
            style: formTextStyle,
            onFieldSubmitted: (String value) {
              lesson.roomname = value;
            },
          ),
        ),
        Box(),
        Center(
          child: Text(
            'Время проведения',
            style: titleTextStyle,
          ),
        ),
        Container(
          decoration: containerDecoration,
          child: TextFormField(
            textAlign: TextAlign.center,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value.isEmpty) return "Пожалуйста, заполните это поле!";
              // if (value.length > 5)
              RegExp regExp = new RegExp(
                r"\b(([0-1]?[0-9]|2[0-3]):[0-5][0-9]) ?- ?(([0-1]?[0-9]|2[0-3]):[0-5][0-9])\b",
              );
              if (!regExp.hasMatch(value))
                return "Пожалуйста, введите корректное время формата HH:MM - HH:MM";
              return null;
            },
            decoration: formDecoration,
            keyboardType: TextInputType.number,
            initialValue: lesson.time.asString(),
            style: formTextStyle,
            onFieldSubmitted: (String value) {
              // lesson.time = IntervalOfTime.fromString(beginAsString, endAsString);
            },
          ),
        ),
      ],
    );
  }
}

TextStyle formTStyle(double width) {
  return TextStyle(
    fontSize: width / 20,
  );
}

InputDecoration textFormDecoration() {
  return InputDecoration(
    // colo
    // fillColor: Colors.grey,
    // focusColor: Colors.grey,
    border: InputBorder.none,
  );
}

BoxDecoration wrapperDecoration() {
  return BoxDecoration(
    color: Colors.teal[50],
    borderRadius: BorderRadius.circular(10.0),
  );
}

TextStyle titleTStyle(double width) {
  return TextStyle(fontSize: width / 20, fontWeight: FontWeight.bold);
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
    );
  }
}
