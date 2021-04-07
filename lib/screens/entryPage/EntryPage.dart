import 'package:flutter/material.dart';
import 'package:schedule/connectivity/connectivity_service.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'DDButton.dart';
import 'package:provider/provider.dart';

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
          onPressed: () async {
            if (provider.canNotShowGroups) {
            } else if (provider.dbFilled) {
              var value = await provider.getCurrentSchedule();
              await Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => DayPage(value)));
            }
          },
        ),
        RaisedButton(
          // color: Colors.grey[200],
          child: Text(
            "Обновить",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            if (provider.dbFilled) {
              provider.refresh(context);
            }
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
  final TextStyle _textStyle =
      TextStyle(/*fontSize: 10,*/ fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        shadowColor: Colors.cyan[400],
        elevation: 6,
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Курс:", style: _textStyle),
              ButtonTheme(
                  alignedDropdown: true,
                  child: FirstDropDownButton(_textStyle)),
              SizedBox(height: 10),
              Text("Направление:", style: _textStyle),
              ButtonTheme(
                  alignedDropdown: true,
                  child: SecondDropDownButton(_textStyle)),
              SizedBox(height: 10),
              Text("Группа:", style: _textStyle),
              ButtonTheme(
                alignedDropdown: true,
                child: ThirdDropDowButton(_textStyle),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
