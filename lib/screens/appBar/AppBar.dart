import 'package:flutter/material.dart';

//сам эппбар
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text('MMCS_TimeTable'),
      actions: [
        FlatButton(
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

class EditPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text('MMCS_TimeTable'),
      actions: [
        FlatButton(
          highlightColor: Colors.transparent,
          onPressed: () {
            showDialog<void>(
                context: context, builder: (context) => EditPageHelpDialog());
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

class EditPageHelpDialog extends StatelessWidget {
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
