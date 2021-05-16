import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule/main.dart' show SizeProvider;
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/screens/editPages/editPage/editPageProvider.dart';
import 'package:schedule/screens/editPages/editPage/editPageWidgets.dart';
import 'package:schedule/screens/editPages/editModePage/editProvider.dart';
import 'package:schedule/screens/widgetsHelper/widgetsHelper.dart';
import '../../appBar/AppBar.dart';

class EditPage extends StatelessWidget {
  static const String routeName =
      '/EntryPage/DayPage/WeekPage/EditModePage/EditPage';
  final NormalLesson lesson;
  EditPage(this.lesson) {
    ModalBottomSheetController.init(lesson.time);
    GroupProvider.init(lesson.groups);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EditPageAppBar(),
      body: EditColumn(lesson),
    );
  }
}

class EditColumn extends StatefulWidget {
  final NormalLesson lesson;
  EditColumn(this.lesson);

  @override
  _EditColumnState createState() => _EditColumnState();
}

class _EditColumnState extends State<EditColumn> {
  final subjectNameKey = GlobalKey<FormFieldState<String>>();
  final subjectAbbrKey = GlobalKey<FormFieldState<String>>();
  final specificKey = GlobalKey<FormFieldState<String>>();
  final roomnameKey = GlobalKey<FormFieldState<String>>();
  final timeKey = GlobalKey<FormFieldState<String>>();
  final InputDecoration formDecoration = textFormDecoration;
  final BoxDecoration containerDecoration = wrapperDecoration;

  String _subjectNameValidator(String value) {
    if (value.isEmpty) return "Пожалуйста, заполните это поле!";
    if (value.length > 60) return "Пожалуйста, сократите назвавание";
    return null;
  }

  String _subjectAbbrValidator(String value) {
    if (value.length > 20) return "Пожалуйста, сократите назвавание";
    if (subjectNameKey.currentState.value.length > 30 && value.length == 0) {
      return "Название предмета слишком длинное. Пожалуйста, введите аббревиатуру";
    }
    return null;
  }

  String _timeValidator(String value) {
    if (value.isEmpty) return "Пожалуйста, заполните это поле!";
    RegExp regExp = new RegExp(
      r"\b(([0-1]?[0-9]|2[0-3]):[0-5][0-9]) ?- ?(([0-1]?[0-9]|2[0-3]):[0-5][0-9])\b",
    );
    if (!regExp.hasMatch(value))
      return "Пожалуйста, введите корректное время формата HH:MM - HH:MM";
    var timeController = ModalBottomSheetController();
    if (!timeController.isIntervalCorrect) {
      return "Пожалуйста, введите корректное время";
    }
    var time = ModalBottomSheetController().time;
    if (EditProvider().isCrossed(time)) {
      return "Время пересекается со временем одной из сегодняшних пар";
    }
    return null;
  }

  String _studentValidator(String value) {
    if (value.length > 40) return "Слишком длинное имя";
    return null;
  }

  String _teacherValidator(String value) {
    if (GroupProvider().groups.length > 12)
      return "Превышено максимальное количество групп (12)";
    return null;
  }

  String _roomnameValidator(String value) {
    if (value.length > 20) return "Пожалуйста, сократите назвавание";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var editor = EditProvider();
    var userIsStudent = (editor.userType == UserType.student);
    NormalLesson newLesson = widget.lesson;
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20),
      children: [
        SizedBox(height: 10),
        TFFWrapper(
          textFormFieldKey: subjectNameKey,
          title: 'Название предмета',
          validator: _subjectNameValidator,
          initialValue: newLesson.subjectname,
        ),
        box(),
        TFFWrapper(
          textFormFieldKey: subjectAbbrKey,
          title: 'Аббревиатура',
          subTitle: '(это поле можете оставить пустым)',
          validator: _subjectAbbrValidator,
          initialValue: newLesson.subjectabbr,
        ),
        box(),
        TFFWrapper(
          textFormFieldKey: specificKey,
          title: userIsStudent ? 'Имя преподавателя' : 'Группы',
          subTitle: '(это поле можете оставить пустым)',
          validator: userIsStudent ? _studentValidator : _teacherValidator,
          initialValue: userIsStudent
              ? newLesson.teachername
              : newLesson.groupsAsString(),
          onTap: userIsStudent ? null : showGroupsMBS,
          readOnly: !userIsStudent,
        ),
        box(),
        TFFWrapper(
          textFormFieldKey: roomnameKey,
          title: 'Аудитория',
          subTitle: '(это поле можете оставить пустым)',
          validator: _roomnameValidator,
          initialValue: newLesson.roomname,
        ),
        box(),
        TFFWrapper(
          textFormFieldKey: timeKey,
          title: 'Время проведения',
          initialValue: newLesson.time.asString().replaceAll(' ', ''),
          validator: _timeValidator,
          readOnly: true,
          onTap: showTimeMBS,
        ),
        box(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              height: SizeProvider().getSize(0.08, from: SizeFrom.height),
              width: SizeProvider().getSize(0.4),
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Отменить",
                style: TextStyle(color: Colors.white),
              ),
            ),
            CustomButton(
              height: SizeProvider().getSize(0.08, from: SizeFrom.height),
              width: SizeProvider().getSize(0.4),
              onTap: () {
                bool canCreate = true;
                var subjectNameCurrentState = subjectNameKey.currentState;
                var subjectAbbrCurrentState = subjectAbbrKey.currentState;
                var specificKeyCurrentState = specificKey.currentState;
                var roomnameCurrentState = roomnameKey.currentState;
                var timeCurrentState = timeKey.currentState;
                canCreate = canCreate &&
                    (subjectNameCurrentState != null
                        ? subjectNameCurrentState.validate()
                        : true);
                canCreate = canCreate &&
                    (subjectAbbrCurrentState != null
                        ? subjectAbbrCurrentState.validate()
                        : true);
                canCreate = canCreate &&
                    (specificKeyCurrentState != null
                        ? specificKeyCurrentState.validate()
                        : true);
                canCreate = canCreate &&
                    (roomnameCurrentState != null
                        ? roomnameCurrentState.validate()
                        : true);
                canCreate = canCreate &&
                    (timeCurrentState != null
                        ? timeCurrentState.validate()
                        : true);
                if (canCreate) {
                  var editor = EditProvider();
                  newLesson.subjectname = subjectNameCurrentState.value;
                  newLesson.subjectabbr = subjectAbbrCurrentState.value;
                  userIsStudent
                      ? newLesson.teachername = specificKeyCurrentState.value
                      : newLesson.groups = GroupProvider().groups;
                  newLesson.roomname = roomnameCurrentState.value;
                  newLesson.time =
                      IntervalOfTime.fromOneString(timeCurrentState.value);
                  editor.newLesson(newLesson);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Изменить",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

Widget box() {
  return SizedBox(
    height: 30,
  );
}
