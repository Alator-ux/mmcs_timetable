import 'package:flutter/material.dart';
import 'main.dart';

class WeekPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeekPageState();
}

class WeekPageState extends State<WeekPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        backgroundColor: Colors.grey,
        body: Container(child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity < 0) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MainApp()),
              );
            } else if (details.primaryVelocity > 0) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MainApp()),
              );
            }
          },
          //child: Container(child: Text('fdjks')),
        )));
  }
}
