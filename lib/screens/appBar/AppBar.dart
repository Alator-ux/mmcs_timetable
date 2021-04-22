import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedule/main.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';

//сам эппбар без секции с помощью
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text('РАСПИСАНИЕ ИММиКН'),
      actions: [
        FlatButton(
          padding: EdgeInsets.symmetric(),
          highlightColor: Colors.transparent,
          onPressed: () {
            showDialog<void>(
                context: context, builder: (context) => EntryPageHelpDialog());
          },
          child: Icon(
            Icons.help,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

//сам эппбар c секцeй с помощью
class MyAppBarHelp extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    SubjectProvider provider = Provider.of<SubjectProvider>(context);
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text('РАСПИСАНИЕ ИММиКН'),
      leading: FlatButton(
        highlightColor: Colors.transparent,
        onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MainPage())),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      actions: [
        MyButton(
          size: 40,
          onTap: () {
            provider.changeCurrentWeek();
          },
          child: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
        ),
        MyButton(
          size: 40,
          onTap: () {
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
      title: Text('РАСПИСАНИЕ ИММиКН'),
      actions: [
        FlatButton(
          padding: EdgeInsets.symmetric(),
          highlightColor: Colors.transparent,
          onPressed: () {
            showDialog<void>(
                context: context, builder: (context) => EntryPageHelpDialog());
          },
          child: Icon(
            Icons.help,
            color: Colors.white,
          ),
        )
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
      content: Text('Для навигации используйте свайп вправо и свайп влево'),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}

class EntryPageHelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Помощь'),
      content: Text(
          'Данные буду вашем носителе, так что вы сможете посмотреть расписание даже без интернета.' +
              'Кнопка "Обновить" перезагрузит на носитель заново'),
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
  String curWeek;
  MyBottomBar(this.curWeek);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.cyan[500],
      child: Text(
        curWeek,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;
  final Widget child;
  const MyButton({Key key, this.size, this.onTap, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO попробовать заменить на InkWell
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}
