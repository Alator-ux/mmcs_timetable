import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';
import 'package:schedule/screens/updateProvider.dart';
import 'notifications/notification_service.dart';
import 'screens/entryPage/EntryPage.dart';

String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notification = NotificationService();
  await notification.configureNotifications();
  initialRoute = await notification.getInitialRoute();
  SettingsProvider settings = SettingsProvider();
  await settings.init();
  initialRoute = settings.isSaved ? DayPage.routeName : MainPage.routeName;
  var ind = settings.isSaved ? 1 : 0;
  NavigationController.create(ind);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: initialRoute,
      // routes: <String, WidgetBuilder>{
      //   MainPage.routeName: (_) => MainPage(),
      //   DayPage.routeName: (_) => DayPage(),
      // },
      home: MyNavigator(),
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

class MyNavigator extends StatefulWidget {
  @override
  _MyNavigatorState createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationController(),
      child: Consumer<NavigationController>(builder: (context, controller, _) {
        return IndexedStack(
          index: controller.index,
          children: [
            MainPage(),
            DayPage(),
          ],
        );
      }),
    );
  }
}

class NavigationController with ChangeNotifier {
  static NavigationController _instance;
  NavigationController._();
  int _index = 0;
  factory NavigationController() {
    _instance ??= NavigationController._();
    return _instance;
  }
  factory NavigationController.create(int ind) {
    _instance ??= NavigationController._();
    _instance._index = ind;
    return _instance;
  }

  int get index {
    return _index;
  }

  void changeScreen(int ind) {
    //TODO enum screen
    _index = ind;
    notifyListeners();
  }
}
