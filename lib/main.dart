import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/API/api_service.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
// import 'schedule/classes/week.dart';
import 'screens/entryPage/EntryPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => RestClient.create(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: MyAppBar(),
          backgroundColor: Colors.white,
          body: ChangeNotifierProvider(
            create: (context) => EntryPageProvider(),
            child: EntryPage(),
          ),
        ),
      ),
    );
  }
}
