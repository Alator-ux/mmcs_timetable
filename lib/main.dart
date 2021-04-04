import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/API/api_service.dart';
// import 'schedule/classes/week.dart';
import 'screens/entryPage/EntryPage.dart';
import 'screens/AppBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => RestClient.create(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: MyAppBar(),
            backgroundColor: Colors.white,
            body:
                // TODO: Call other page
                //io.File("preference.json").existsSync() ? EntryPage() : EntryPage(),
                EntryPage()),
      ),
    );
  }
}
