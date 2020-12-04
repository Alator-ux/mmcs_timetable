import 'package:flutter/material.dart';
import 'package:schedule/schedule/test values/test_values.dart';
import 'DayPage.dart';

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final List<DropdownMenuItem<String>> _courses = courseItems();
  final List<DropdownMenuItem<String>> _groups = groupItems();
  var _course = getCourses()[0];
  var _group = getGroups()[0];
  final TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 22);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Курс:", style: _textStyle),
              DropdownButton<String>(
                items: _courses,
                onChanged: (value) {
                  setState(() {
                    _course = value;
                  });
                },
                value: _course,
                style: _textStyle,
                isDense: true,
                iconSize: 35.0,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Группа:", style: _textStyle),
              DropdownButton<String>(
                items: _groups,
                onChanged: (value) {
                  setState(() {
                    _group = value;
                  });
                },
                value: _group,
                style: _textStyle,
                isDense: true,
                iconSize: 35.0,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        RaisedButton(
          color: Colors.grey[200],
          child: Text(
            "Далее",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DayPage()));
          },
        )
      ],
    );
  }
}
