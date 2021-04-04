import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/test%20values/test_values.dart';

class FirstDropDownButton extends StatefulWidget {
  final Stream<List<Grade>> _apiStream;
  final StreamController<int> _controller;
  final List<Grade> _grades;
  final TextStyle _textStyle;
  FirstDropDownButton(
      this._grades, this._textStyle, this._controller, this._apiStream);
  @override
  _FirstDropDownButtonState createState() =>
      _FirstDropDownButtonState(_grades, _textStyle, _controller);

  static Grade getGrade() {
    return _FirstDropDownButtonState._grade;
  }

  static int getGradeID() {
    return _FirstDropDownButtonState._gradeID;
  }
}

class _FirstDropDownButtonState extends State<FirstDropDownButton> {
  final StreamController<int> _controller;
  final TextStyle _textStyle;
  List<Grade> _grades;
  List<DropdownMenuItem<Grade>> _gradeItems;
  static Grade _grade;
  static int _gradeID = 1;
  _FirstDropDownButtonState(this._grades, this._textStyle, this._controller) {
    _gradeItems = gradeItems(_grades);
    _grade = _gradeItems.first.value;
    _gradeID = _grade.id;
  }

  void _updateByApi(List<Grade> gradelist) {
    setState(() {
      // print(_gradeID);
      _grades = gradelist;
      _gradeID = gradelist.first.id;
      _gradeItems = gradeItems(_grades);
      _grade = _gradeItems.first.value;
      _controller.add(_gradeID);
    });
  }

  @override
  void initState() {
    super.initState();
    widget._apiStream.listen((gradelist) {
      _updateByApi(gradelist);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Grade>(
      items: _gradeItems,
      onChanged: (value) {
        _controller.add(value.id);
        setState(() {
          _grade = value;
          _gradeID = value.id;
        });
      },
      value: _grade,
      style: _textStyle,
      isDense: true,
      iconSize: 35.0,
    );
  }
}

//------------------------------------------------//

class SecondDropDownButton extends StatefulWidget {
  final Stream<List<List<Group>>> apiStream;
  final Stream<int> stream;
  final StreamController<String> _controller;
  final List<List<Group>> _groups;
  final TextStyle _textStyle;
  SecondDropDownButton(this._groups, this._textStyle, this.stream,
      this._controller, this.apiStream);
  @override
  _SecondDropDownButtonState createState() =>
      _SecondDropDownButtonState(_groups, _textStyle, _controller);

  static String getProg() {
    return _SecondDropDownButtonState._prog;
  }
}

class _SecondDropDownButtonState extends State<SecondDropDownButton> {
  final TextStyle _textStyle;
  final StreamController<String> _controller;
  List<List<Group>> _groups;
  List<DropdownMenuItem<String>> _progItems;
  static String _prog;
  int _gradeID = FirstDropDownButton.getGradeID();
  _SecondDropDownButtonState(this._groups, this._textStyle, this._controller) {
    _progItems = progItems(_groups, _gradeID);
    _prog = _progItems.first.value;
  }

  void _updateByApi(List<List<Group>> groups) {
    _groups = groups;
    _updateProg(_groups.first.first.gradeid);
  }

  void _updateProg(int gradeID) {
    setState(() {
      _gradeID = gradeID;
      _progItems = progItems(_groups, _gradeID);
      _prog = _progItems.first.value;
      _controller.add(_prog);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.apiStream.listen((grouplists) {
      _updateByApi(grouplists);
    });
    widget.stream.listen((gradeid) {
      _updateProg(gradeid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: _progItems,
      onChanged: (value) {
        _controller.add(value);
        setState(() {
          _prog = value;
        });
      },
      value: _prog,
      style: _textStyle,
      isDense: true,
      iconSize: 35.0,
    );
  }
}

class ThirdDropDowButton extends StatefulWidget {
  final Stream<List<List<Group>>> apiStream;
  final Stream<String> stream;
  final List<List<Group>> _groups;
  final TextStyle _textStyle;

  ThirdDropDowButton(
      this._groups, this._textStyle, this.stream, this.apiStream);

  @override
  _ThirdDropDowButtonState createState() =>
      _ThirdDropDowButtonState(_groups, _textStyle);

  static Group getGrade() {
    return _ThirdDropDowButtonState._group;
  }
}

class _ThirdDropDowButtonState extends State<ThirdDropDowButton> {
  final TextStyle _textStyle;
  List<DropdownMenuItem<Group>> _groupItems;
  List<List<Group>> _groups;
  static Group _group;
  int _gradeID = FirstDropDownButton.getGradeID();
  String _progName = SecondDropDownButton.getProg();

  _ThirdDropDowButtonState(this._groups, this._textStyle) {
    _groupItems = groupItems(_groups, _gradeID, _progName);
    _group = _groupItems.first.value;
  }

  void _updateByApi(List<List<Group>> groups) {
    _groups = groups;
  }

  void _updateGrade(String progName) {
    setState(() {
      _gradeID = FirstDropDownButton.getGradeID();
      _groupItems = groupItems(_groups, _gradeID, progName);
      _group = _groupItems.first.value;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.apiStream.listen((grouplists) {
      _updateByApi(grouplists);
    });
    widget.stream.listen((progName) {
      _updateGrade(progName);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_group == null) _group = _groupItems.first.value;
    return DropdownButton<Group>(
      items: _groupItems,
      onChanged: (value) {
        setState(() {
          _group = value;
        });
      },
      value: _group,
      style: _textStyle,
      isDense: true,
      iconSize: 35.0,
    );
  }
}
