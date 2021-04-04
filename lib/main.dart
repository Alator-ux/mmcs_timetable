import 'package:flutter/material.dart';
// import 'schedule/classes/week.dart';
// import 'dart:io' as io;
import 'screens/EntryPage.dart';
import 'screens/AppBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          bottomNavigationBar: MyBottomBar(),
          appBar: MyAppBar(),
          body:
              // TODO: Call other page
              //io.File("preference.json").existsSync() ? EntryPage() : EntryPage(),
              EntryPage()),
    );
  }
}
