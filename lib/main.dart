import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'notifications/notification_service.dart';
import 'screens/entryPage/EntryPage.dart';

String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notification = NotificationService();
  await notification.configureNotifications();
  initialRoute = await notification.getInitialRoute();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        MainPage.routeName: (_) => MainPage(),
        DayPage.routeName: (_) => DayPage(),
      },
      builder: (context, child) {
        var size = MediaQuery.of(context).size;
        SizeProvider()..setSize(size.width, size.height);
        return child;
      },
    );
  }
}

class MainPage extends StatelessWidget {
  static const String routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => EntryPageProvider(),
        child: EntryPage(),
      ),
    );
  }
}

class SizeProvider {
  static SizeProvider _instance;
  double width;
  double height;
  SizeProvider._();
  factory SizeProvider() {
    _instance ??= SizeProvider._();
    return _instance;
  }
  void setSize(double width, double height) {
    this.width = width;
    this.height = height;
  }
}
