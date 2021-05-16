import 'package:flutter/material.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/settingsPage/SettingsPage.dart';
import 'package:schedule/screens/widgetsHelper/widgetsHelper.dart';

const String entryPageHelpDialog =
    'Функция \'Зайти в сохраненное\' доступна лишь после того,' +
        ' как вы сохраните какое-нибудь расписание в настройках.';
const String displayPagesHelpDialog =
    'Для навигации используйте свайп вправо и свайп влево.\n' +
        'Для редактирования пар дня зажмите плашку этого дня на экране отображения расписания всей недели.\n' +
        'Для просмотра более подробной инофрмации о паре на экране расписания недели нажмите на плашку это пары.\n' +
        'Сменить неделю вы можете через меню в правом верхнем углу экрана.';

const String editModePageHelpDialog =
    'Для редактирования пары нажмите на иконку карандаша на плашке пары справа.\n' +
        'Для добавления пары на этот день нажните на кнопку с иконокой плюса в правом нижнем углу.\n' +
        'Для удаления пары смахните плашку с этой парой вправо.\n' +
        'Для сохранения любых изменений нажмите на зеленую кнопку.';

const String editPageHelpDialog =
    'При нажатии на кнопку \'Изменить\' выбранная/новая пара будет изменена в соответветствии с внесенными данными (если они корректны), ' +
        'однако чтобы окончателльно внести изменения вам нужно будет подтвердить их на предыдущей странице, нажав на кнопку сохранения.\n' +
        'При нажатии на кнопку \'Отменить\' или на стрелку назад изменения внесены не будут.\n';

const String settingsPageHelpDialog =
    'Для сохранения и последующего отслеживания внесенных изменений выбранного расписания ' +
        'нажмите кнопку \'Сохранить\'.';

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
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (context) => HelpDialog(entryPageHelpDialog));
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
              context: context,
              builder: (context) => HelpDialog(displayPagesHelpDialog),
            );
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
      actions: [
        TextButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (context) => HelpDialog(editPageHelpDialog));
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

class EditModePageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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
      actions: [
        TextButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (context) => HelpDialog(editModePageHelpDialog));
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

class SettingsPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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
      actions: [
        TextButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (context) => HelpDialog(settingsPageHelpDialog));
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
  final String text;
  HelpDialog(this.text);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Помощь'),
      content: Text(text),
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
