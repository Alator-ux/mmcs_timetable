import 'package:flutter/material.dart';
import 'main.dart';

class DayLess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Para '),
        Row(children: [Text('Time')])
      ],
    );
  }
}

class Day extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DayState();
}

class DayState extends State<Day> {
  @override
  Widget build(BuildContext context) {
    return (ListView(
      children: [
        Text('para1'),
        Text('para2'),
        Text('para3'),
        Text('para4'),
      ],
    ));
  }
}

class WeekPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeekPageState();
}

class WeekPageState extends State<WeekPage> {
  final dayindex = 6;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        backgroundColor: Colors.grey,
        body: GestureDetector(
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
            child: Container(
              child: ListView.separated(
                  itemCount: dayindex,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text('day ${index + 1}'),
                      children: [
                        DayLess(),
                      ],
                    );
                  }),
            )));
  }
}
