import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/screens/EntryPage.dart';
import 'package:intl/intl.dart';

//сам эппбар без секции с помощью
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text('MMCS_TimeTable'),
    );
  }
}

//сам эппбар c секцeй с помощью
class MyAppBarHelp extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text('MMCS_TimeTable'),
      leading: FlatButton(
        highlightColor: Colors.transparent,
        onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    Scaffold(appBar: MyAppBar(), body: EntryPage()))),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      actions: [
        FlatButton(
          padding: EdgeInsets.symmetric(),
          highlightColor: Colors.transparent,
          onPressed: () {
            showDialog<void>(
                context: context, builder: (context) => HelpDialog());
          },
          child: Icon(
            Icons.help,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

//окно с информацией по навигации
class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Помощь'),
      content: Text(
          'Для навигации используйсте смахивания (свайпы): влево (для прехода к окну с неделями) или вправо (для возврата к текущему дню).'),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}

//боттом бар
class MyBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyy');
    final String formatted = formatter.format(now);
    return BottomAppBar(
      color: Colors.cyan[500],
      child: Text(
        formatted,
        textAlign: TextAlign.center,
      ),
    );
  }
}
