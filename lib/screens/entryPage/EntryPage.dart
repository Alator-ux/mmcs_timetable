import 'package:flutter/material.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'DDButton.dart';
import 'package:provider/provider.dart';

import '../DayPage.dart';

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  EntryPageProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EntryPageProvider>(context);
    return Column(
      children: [
        InformationCard(),
        SizedBox(height: 20),
        RaisedButton(
          color: Colors.grey[200],
          child: Text(
            "Далее",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            // Navigator.push(
            // context, MaterialPageRoute(builder: (context) => DayPage(provider.currentGroup)));
          },
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
  final TextStyle _textStyle = TextStyle(color: Colors.black);

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
                FirstDropDownButton(_textStyle),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Направление:", style: _textStyle),
                SecondDropDownButton(_textStyle),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Группа:", style: _textStyle),
                ThirdDropDowButton(_textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
