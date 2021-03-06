import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/displayPages/DayPage.dart';
import 'package:schedule/screens/entryPage/EntryPageProvider.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';
import 'notifications/notification_service.dart';
import 'screens/entryPage/EntryPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notification = NotificationService();
  await notification.configureNotifications();
  SettingsProvider settings = SettingsProvider();
  await settings.init();
  var route = settings.isSaved ? ScreenRoute.displayPage : ScreenRoute.mainPage;
  NavigationController.create(route);

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
  double _width;
  double _height;
  SizeProvider._();
  factory SizeProvider() {
    _instance ??= SizeProvider._();
    return _instance;
  }
  double get width => _width;
  double get height => _height;
  void setSize(double width, double height) {
    this._width = width;
    this._height = height;
  }

  double getSize(double coef, {SizeFrom from = SizeFrom.width}) {
    var _from = from == SizeFrom.width ? width : height;
    return coef * _from;
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
          index: controller.route.index,
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
  ScreenRoute _route = ScreenRoute.mainPage;
  factory NavigationController() {
    _instance ??= NavigationController._();
    return _instance;
  }
  factory NavigationController.create(ScreenRoute route) {
    _instance ??= NavigationController._();
    _instance._route = route;
    return _instance;
  }

  ScreenRoute get route {
    return _route;
  }

  void changeScreen(ScreenRoute route) {
    _route = route;
    notifyListeners();
  }
}
