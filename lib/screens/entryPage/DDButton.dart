import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/test_values/test_values.dart';
import 'package:provider/provider.dart';
import 'EntryPageProvider.dart';

class FirstDropDownButton extends StatefulWidget {
  final TextStyle _textStyle;
  FirstDropDownButton(this._textStyle);
  @override
  _FirstDropDownButtonState createState() => _FirstDropDownButtonState();
}

class _FirstDropDownButtonState extends State<FirstDropDownButton> {
  EntryPageProvider provider;
  // TextStyle _textStyle;
  List<DropdownMenuItem<Grade>> _gradeItems;
  Grade _grade;
  bool flag = false;

  _FirstDropDownButtonState() {
    // _textStyle = widget._textStyle;
  }

  void _update(List<Grade> gradelist) {
    _gradeItems = gradeItems(provider);
    if (!flag) {
      _grade = _gradeItems.first.value;
    }
    // provider.changeGradeID(provider.grades.first.id);
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<EntryPageProvider>(context);
    _update(provider.grades);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Grade>(
      items: _gradeItems,
      onChanged: (value) {
        // setState(
        // () {
        _grade = value;
        flag = true;
        provider.changeGradeID(value.id);
        // },
        // );
      },
      value: _grade,
      // style: _textStyle,
      isDense: true,
      iconSize: 35.0,
      isExpanded: true,
    );
  }
}

//------------------------------------------------//

class SecondDropDownButton extends StatefulWidget {
  final TextStyle _textStyle;
  const SecondDropDownButton(this._textStyle);
  @override
  _SecondDropDownButtonState createState() => _SecondDropDownButtonState();
}

class _SecondDropDownButtonState extends State<SecondDropDownButton> {
  EntryPageProvider provider;
  // TextStyle _textStyle;
  // List<List<Group>> _groups;
  List<DropdownMenuItem<String>> _progItems;
  String _prog = '-';
  int oldid = 0;
  bool flag = false;
  _SecondDropDownButtonState();

  void _update(int gradeID) {
    int id = provider.currentGradeID;
    _progItems = progItems(provider);
    if (!flag || id != oldid) {
      _prog = _progItems.first.value;
      oldid = id;
      // provider.currentProgName = _prog;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<EntryPageProvider>(context);
    _update(provider.currentGradeID);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: _progItems,
      onChanged: (value) {
        // setState(() {
        _prog = value;
        flag = true;
        provider.changeProgName(value);
        // });
      },
      value: _prog,
      // style: widget._textStyle,
      isDense: true,
      iconSize: 35.0,
      isExpanded: true,
    );
  }
}

class ThirdDropDowButton extends StatefulWidget {
  final TextStyle _textStyle;

  const ThirdDropDowButton(this._textStyle);

  @override
  _ThirdDropDowButtonState createState() => _ThirdDropDowButtonState();
}

class _ThirdDropDowButtonState extends State<ThirdDropDowButton> {
  EntryPageProvider provider;
  // TextStyle _textStyle;
  List<DropdownMenuItem<Group>> _groupItems;
  // List<List<Group>> _groups;
  Group _group;
  bool flag = false;
  int id = 0;
  String progName;
  _ThirdDropDowButtonState() {
    // _textStyle = widget._textStyle;
  }

  void _update(String newProgName) {
    // _groups = provider.allgroups;
    int newid = provider.currentGradeID;
    _groupItems = groupItems(provider);
    if (!flag || newid != id || newProgName != progName) {
      _group = _groupItems.first.value;
      id = newid;
      progName = newProgName;
    }
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<EntryPageProvider>(context);
    _update(provider.currentProgName);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Group>(
      items: _groupItems,
      onChanged: (value) {
        // setState(() {
        _group = value;
        flag = true;
        provider.changeGroup(value);
        // });
      },
      value: _group,
      // style: widget._textStyle,
      isDense: true,
      iconSize: 35.0,
      isExpanded: true,
    );
  }
}
