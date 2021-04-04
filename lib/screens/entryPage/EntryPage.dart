import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/api/api_service.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:provider/provider.dart';
import 'DDButton.dart';
import '../DayPage.dart';

class EntryPage extends StatelessWidget {
  final StreamController<List<Grade>> _apiGradeController =
      StreamController<List<Grade>>();
  final StreamController<List<List<Group>>> _apiGroupController =
      StreamController<List<List<Group>>>.broadcast();
  List<Grade> _grades = [];
  List<List<Group>> _groups = [];

  @override
  Widget build(BuildContext context) {
    final api = RestClient.create();

    api.getGrades().then((value) {
      // _grades.clear();
      value.forEach((element) {
        _grades.add(element);
      });
      print('suc');

      Future.forEach(_grades, ((grade) {
        api.getGroups(grade.id).then((value) {
          _groups.add(value);
        }).then((value) {
          _apiGroupController.add(_groups);
        });
        print('suc 2');
        // _progController.add(_groups.first.first.name);

        // _gradeController.add(value.first.id);
      }));
    }).then((value) {
      _apiGradeController.add(_grades);
    });

    return Provider(
      create: (context) => _apiGradeController,
      child: Column(
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
      ),
    );
  }
}

class InformationCard extends StatelessWidget {
  StreamController<List<Grade>> _apiGradeController;
  StreamController<List<List<Group>>> _apiGroupController;
  StreamController<int> _gradeController = StreamController<int>();
  StreamController<String> _progController = StreamController<String>();
  List<Grade> _grades;
  List<List<Group>> _groups;
  final TextStyle _textStyle = TextStyle(color: Colors.black);
  static Group getGroup() {
    return ThirdDropDowButton.getGrade();
  }

  InformationCard(this._grades, this._groups, this._apiGradeController,
      this._apiGroupController);
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
                FirstDropDownButton(_grades, _textStyle, _gradeController,
                    _apiGradeController.stream),
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
                    _groups,
                    _textStyle,
                    _gradeController.stream,
                    _progController,
                    _apiGroupController.stream),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Группа:", style: _textStyle),
                ThirdDropDowButton(_groups, _textStyle, _progController.stream,
                    _apiGroupController.stream),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
