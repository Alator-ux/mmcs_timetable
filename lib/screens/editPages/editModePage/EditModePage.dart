import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/displayPages/WeekPage.dart';
import 'package:schedule/screens/editPages/editPage/EditPage.dart';
import 'package:schedule/screens/editPages/editModePage/editProvider.dart';
import 'package:schedule/screens/widgetsHelper/widgetsHelper.dart';

class EditModePage extends StatelessWidget {
  static const String routeName = '/EntryPage/DayPage/WeekPage/EditModePage';
  EditModePage(int dayID) {
    EditProvider.init(dayID);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: EditProvider(),
      child: EditModePageHelper(),
    );
  }
}

class EditModePageHelper extends StatefulWidget {
  @override
  _EditModePageHelperState createState() => _EditModePageHelperState();
}

class _EditModePageHelperState extends State<EditModePageHelper> {
  EditProvider editor;
  final double width = SizeProvider().width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    editor = Provider.of<EditProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: width * 0.05);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'first FAB',
            tooltip: "Сохранить изменения",
            backgroundColor: Colors.lightGreen[500],
            foregroundColor: Colors.white,
            onPressed: () async {
              await editor.save();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Расписание на день сохранено'),
                ),
              );
            },
            child: Icon(Icons.check, size: 35),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'second FAB',
            tooltip: "Добавить пару",
            backgroundColor: Colors.cyan[600],
            foregroundColor: Colors.white,
            onPressed: () {
              if (editor.canAdd) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(
                      NormalLesson.empty(editor.dayId, editor.selectedWeek),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Достигнуто максимальное количество запланированных пар на день (10)'),
                  ),
                );
              }
            },
            child: Icon(Icons.add, size: 35),
          ),
        ],
      ),
      appBar: EditPageAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.cyan[50],
                child: Center(
                  child: Text(
                    DaysOfWeek.values[editor.dayId].asString(),
                    style: _textStyle,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // ListView.separated(
            //   itemCount: ,
            // ),
            editMode(context),
          ],
        ),
      ),
    );
  }
}

Widget editMode(BuildContext context) {
  var editor = EditProvider();
  var lessons = editor.lessons;
  double width = SizeProvider().width;
  TextStyle _textStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: width * 0.04);
  TextStyle _timeTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: width * 0.045);
  var uniqueKeys = [];
  lessons.forEach((lesson) {
    uniqueKeys.add(UniqueKey());
  });
  var i = 0;
  return Column(
      children: editor.lessons.map(
    (lesson) {
      return Dismissible(
        key: uniqueKeys[i++],
        onDismissed: (_) {
          editor.deleteLesson(lesson);
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.delete),
        ),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              showDialog<void>(
                  context: context,
                  builder: (context) =>
                      lessonInfo(context, editor.userType, lesson));
            },
            child: Card(
              color: Colors.cyan[50],
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          lesson.time.asString(),
                          style: _timeTextStyle,
                        ),
                        SizedBox(width: 10),
                        Text(
                          lesson.subjectabbr.isEmpty
                              ? lesson.subjectname
                              : lesson.subjectabbr,
                          style: _textStyle,
                          // style: _textStyle,
                        ),
                      ],
                    ),
                    MyButton(
                      size: width * 0.1,
                      onTap: () {
                        editor.nowEditing = editor.lessons.indexOf(lesson);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditPage(lesson)),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).toList());
}
