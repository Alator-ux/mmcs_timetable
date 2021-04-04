import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'DDButton.dart';
import '../DayPage.dart';

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final StreamController<List<Grade>> _apiGradeController =
      StreamController<List<Grade>>();

  final StreamController<List<List<Group>>> _apiGroupController =
      StreamController<List<List<Group>>>.broadcast();

  @override
  void dispose() {
    super.dispose();
    _apiGradeController.close();
    _apiGroupController.close();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fillGrades(),
      builder: (context, snapshot) {
        return Column(
          children: [
            InformationCard(
                _grades, _groups, _apiGradeController, _apiGroupController),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.grey[200],
              child: Text(
                "Далее",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => DayPage(InformationCard.getGroup())));
              },
            ),
          ],
        );
      },
    );
  }
}

class InformationCard extends StatefulWidget {
  final StreamController<List<Grade>> _apiGradeController;
  final StreamController<List<List<Group>>> _apiGroupController;
  final List<Grade> _grades;
  final List<List<Group>> _groups;

  static Group getGroup() {
    return ThirdDropDowButton.getGrade();
  }

  InformationCard(this._grades, this._groups, this._apiGradeController,
      this._apiGroupController);

  @override
  _InformationCardState createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  StreamController<int> _gradeController = StreamController<int>();

  StreamController<String> _progController = StreamController<String>();

  final TextStyle _textStyle = TextStyle(color: Colors.black);

  @override
  void dispose() {
    super.dispose();
    _gradeController.close();
    _progController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.cyan[400],
      elevation: 6,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Курс:", style: _textStyle),
                FirstDropDownButton(widget._grades, _textStyle,
                    _gradeController, widget._apiGradeController.stream),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Направление:", style: _textStyle),
                SecondDropDownButton(
                    widget._groups,
                    _textStyle,
                    _gradeController.stream,
                    _progController,
                    widget._apiGroupController.stream),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Группа:", style: _textStyle),
                ThirdDropDowButton(widget._groups, _textStyle,
                    _progController.stream, widget._apiGroupController.stream),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
