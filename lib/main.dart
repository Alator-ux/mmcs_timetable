import 'package:flutter/material.dart';
import 'week.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text('MMCS_TimeTable'),
    );
  }
}

// ignore: must_be_immutable
class Subjects extends StatelessWidget {
  var time = '08:00';
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Container(
              child: Container(
                color: Color.fromARGB(255, 178, 34, 34),
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Column(children: [
                  EzBox(),
                  Text('Time $time \nauditoriya'),
                  EzBox(),
                  EZline(),
                  EzBox(),
                  Text('Para \nprepod'),
                ]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Container(
              child: Container(
                color: Color.fromARGB(255, 178, 34, 34),
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Column(children: [
                  EzBox(),
                  Text('Time $time \nauditoriya'),
                  EzBox(),
                  EZline(),
                  EzBox(),
                  Text('Para \nprepod'),
                ]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Container(
              child: Container(
                color: Color.fromARGB(255, 178, 34, 34),
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Column(children: [
                  EzBox(),
                  Text('Time $time \nauditoriya'),
                  EzBox(),
                  EZline(),
                  EzBox(),
                  Text('Para \nprepod'),
                ]),
              ),
            ),
          ),
          /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                child: Container(
                  color: Color.fromARGB(255, 178, 34, 34),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Column(children: [
                    EzBox(),
                    Text('Time $time \nauditoriya'),
                    EzBox(),
                    EZline(),
                    EzBox(),
                    Text('Para \nprepod'),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                child: Container(
                  color: Color.fromARGB(255, 178, 34, 34),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Column(children: [
                    EzBox(),
                    Text('Time $time \nauditoriya'),
                    EzBox(),
                    EZline(),
                    EzBox(),
                    Text('Para \nprepod'),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                child: Container(
                  color: Color.fromARGB(255, 178, 34, 34),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Column(children: [
                    EzBox(),
                    Text('Time $time \nauditoriya'),
                    EzBox(),
                    EZline(),
                    EzBox(),
                    Text('Para \nprepod'),
                  ]),
                ),
              ),
            ),*/
        ]));
  }
}

class EZline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Divider(
        color: Colors.black,
      ),
    );
  }
}

class EzBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 15,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity < 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WeekPage()),
          );
        } else if (details.primaryVelocity > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WeekPage()),
          );
        }
      },
      child: Subjects(),
    ));
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(),
        body: HomePage(),
      ),
    );
  }
}

void main() => runApp(MainApp());
