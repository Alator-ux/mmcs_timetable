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
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // TextStyle _textStyle = TextStyle(fontSize: width / 25);
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
            } else if (!provider.dbFilled) {
              ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(
                  content: new Text("Пожалуйста, подождите"),
                ),
              );
            } else {
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
          onPressed: provider.isOnline
              ? () {
                  if (provider.dbFilled) {
                    provider.refresh(context);
                  }
                }
              : null,
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextStyle _textStyle =
        TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold);
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
