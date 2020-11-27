import 'package:flutter/material.dart';

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
  final time = 6;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Container(
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
          ])),
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: HomePage(),
      ),
    ));
