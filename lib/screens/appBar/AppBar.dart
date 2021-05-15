import 'package:flutter/material.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/settingsPage/SettingsPage.dart';

//Апп бар для EntryPage
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final sizeCoef = SizeProvider().width;
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text(
        'РАСПИСАНИЕ ИММиКН',
        style: TextStyle(fontSize: sizeCoef * 0.042),
      ),
      actions: [
        TextButton(
          // style: ButtonStyle(

          //     ),
          // highlightColor: Colors.transparent,
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

//Апп бар для дисплей страниц
class MyAppBarHelp extends StatelessWidget implements PreferredSizeWidget {
  final sizeCoef = SizeProvider().width;
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text(
        'РАСПИСАНИЕ ИММиКН',
        style: TextStyle(fontSize: sizeCoef * 0.042),
      ),
      leading: MyButton(
        onTap: () {
          var controller = NavigationController();
          controller.changeScreen(ScreenRoute.mainPage);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        size: sizeCoef * 0.13,
      ),
      actions: [
        MyButton(
          size: sizeCoef * 0.125,
          onTap: () {
            showDialog<void>(
                context: context, builder: (context) => HelpDialog());
          },
          child: Icon(
            Icons.help,
            color: Colors.white,
          ),
        ),
        MyButton(
          size: sizeCoef * 0.125,
          child: PopupMenuButton(
            tooltip: 'Меню',
            onSelected: (choice) =>
                _handleClick(context: context, choice: choice),
            itemBuilder: (BuildContext context) {
              return {'Сменить неделю', 'Настройки'}.map(
                (String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                },
              ).toList();
            },
          ),
        ),
      ],
    );
  }
}

void _handleClick({BuildContext context, String choice}) {
  SubjectProvider provider = SubjectProvider();
  switch (choice) {
    case 'Сменить неделю':
      provider.changeSelectedWeek();
      break;
    case 'Настройки':
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => SettingsPage()));
      break;
  }
}

//Апп бар для страницы редактирования
class EditPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(50);
  final sizeCoef = SizeProvider().width;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan[500],
      centerTitle: true,
      title: Text(
        'РАСПИСАНИЕ ИММиКН',
        style: TextStyle(fontSize: sizeCoef * 0.042),
      ),
      leading: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      actions: [
        TextButton(
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

//окно с информацией по навигации для дисплей страниц
class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Помощь'),
      content: Text('Для навигации используйте свайп вправо и свайп влево'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}

//окно с информацией по навигации для страницы входа
class EntryPageHelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Помощь'),
      content: Text(
          'Данные буду вашем носителе, так что вы сможете посмотреть расписание даже без интернета.' +
              'Кнопка "Обновить" перезагрузит на носитель заново'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}

//боттом бар
class MyBottomBar extends StatelessWidget {
  TypeOfWeek currentWeek;
  TypeOfWeek selectedWeek;
  MyBottomBar({this.selectedWeek, this.currentWeek});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.cyan[500],
      child: Text(
        selectedWeek.asString() +
            (currentWeek == selectedWeek ? " (текущая)" : "") +
            " неделя",
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
    return InkWell(
      onTap: onTap,
      child: Ink(
        child: Container(
          width: size,
          height: size,
          child: child,
        ),
      ),
    );
  }
}
