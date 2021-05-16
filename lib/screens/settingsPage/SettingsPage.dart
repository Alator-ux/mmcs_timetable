import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/main.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';
import 'package:schedule/screens/widgetsHelper/widgetsHelper.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: ChangeNotifierProvider.value(
        value: SettingsProvider(),
        child: _SettingsPage(),
      ),
    );
  }
}

class _SettingsPage extends StatefulWidget {
  @override
  __SettingsPageState createState() => __SettingsPageState();
}

class __SettingsPageState extends State<_SettingsPage> {
  SettingsProvider settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settings = Provider.of<SettingsProvider>(context);
  }

  void showSnackBar(String text) {
    var messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget saveButton() {
    var settings = SettingsProvider();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Сохранять данное' + '\n' + 'расписание на устройстве',
        ),
        CustomButton(
          onTap: () async {
            if (settings.overWrite) {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Предупреждение'),
                  content: Text(
                      'Ваше прошлое расписание будет перезаписано, вы уверены?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Отмена')),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        showSnackBar(
                            'Расписание сохранено. Теперь вы можете его редактировать и пользоваться уведомлениями');
                        await settings.save();
                      },
                      child: Text('Да'),
                    ),
                  ],
                ),
              );
            } else {
              showSnackBar('Расписание уже сохранено');
            }
          },
          child: Text(
            'Сохранить',
            style: TextStyle(color: Colors.white),
          ),
          height: SizeProvider().getSize(0.06, from: SizeFrom.height),
          width: SizeProvider().getSize(0.33),
        ),
      ],
    );
  }

  Widget recoverButton() {
    var settings = SettingsProvider();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Вернуть текущее расписание' + '\n' + 'к изначальному виду  ',
        ),
        CustomButton(
          onTap: (settings.isSaved && !settings.overWrite)
              ? () async {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Предупреждение'),
                      content: Text(
                          'Ваше текущее расписание будет перезаписано, вы уверены? Для этого не потребуется подключение к интернету.'),
                      actions: [
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                showSnackBar('Расписание перезаписано');
                                await settings.refreshSchedule();
                              },
                              child: Text('Да'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              : () {
                  showSnackBar(
                      'Для восстановления расписания его сначала необходимо сохранить');
                },
          child: Text(
            'Перезаписать',
            style: TextStyle(color: Colors.white),
          ),
          height: SizeProvider().getSize(0.06, from: SizeFrom.height),
          width: SizeProvider().getSize(0.33),
        ),
      ],
    );
  }

  Widget notificationControllerCheckBox() {
    var settings = SettingsProvider();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Включить push-уведомления',
        ),
        Checkbox(
          value: (settings.isSaved && !settings.overWrite)
              ? settings.pushOn
              : false,
          onChanged: (settings.isSaved && !settings.overWrite)
              ? (pushOn) async {
                  if (pushOn) {
                    await settings.notificationsOn();
                    showSnackBar('Push-уведомления включены');
                  } else {
                    await settings.notificationsOff();
                    showSnackBar('Push-уведомления отключены');
                  }
                }
              : null,
        ),
      ],
    );
  }

  Widget notificationTimeController() {
    var settings = SettingsProvider();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Время пуш уведомления до пары'),
        DropdownButton(
          hint: const Text(' '),
          iconSize: 24,
          items: settings.pushNotifTimeDDMItems,
          value: settings.pushNotifTime,
          onChanged:
              (settings.isSaved && !settings.overWrite && settings.pushOn)
                  ? (value) async {
                      await settings.changePushNotifTime(value);
                    }
                  : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsPageAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            saveButton(),
            SizedBox(height: 15),
            recoverButton(),
            SizedBox(height: 15),
            notificationControllerCheckBox(),
            SizedBox(height: 15),
            notificationTimeController(),
          ],
        ),
      ),
    );
  }
}
