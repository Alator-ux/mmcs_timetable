import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/screens/appBar/AppBar.dart';
import 'package:schedule/screens/displayPages/subjectProvider.dart';
import 'package:schedule/screens/settingsPage/settingsProvider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SettingsProvider(),
      child: _SettingsPage(),
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

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = SettingsProvider();
    return Scaffold(
      appBar: EditPageAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сохранять данное' + '\n' + 'расписание на устройстве',
                ),
                TextButton(
                  onPressed: () async {
                    if (settings.overWrite) {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Предупреждение'),
                          content: Text(
                              'Ваше прошлое расписание будет перезаписано, вы уверены?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   //TODO исправить не показ
                                //   SnackBar(
                                //     content: Text(
                                //         'Расписание сохранено. Теперь вы можете его редактировать и пользоваться уведомлениями'),
                                //   ),
                                // );
                                Navigator.pop(context);
                                await settings.save();
                              },
                              child: Text('Да'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Отмена')),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Расписание сохранено. Теперь вы можете его редактировать и пользоваться уведомлениями'),
                        ),
                      );
                      await settings.save();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.cyan[600]),
                  ),
                  child: Text(
                    'Сохранить',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Push-уведомления включены'),
                              ),
                            );
                          } else {
                            await settings.notificationsOff();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Push-уведомления отключены'),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Время пуш уведомления до пары'),
                DropdownButton(
                  hint: const Text(' '),
                  iconSize: 24,
                  items: _pushNotifTimes,
                  value: settings.pushNotifTime,
                  onChanged: (settings.isSaved &&
                          !settings.overWrite &&
                          settings.pushOn)
                      ? (value) async {
                          await settings.changePushNotifTime(value);
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final List<DropdownMenuItem> _pushNotifTimes = [
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 0),
    child: Text('0 мин'),
  ),
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 5),
    child: Text('5 мин'),
  ),
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 10),
    child: Text('10 мин'),
  ),
  DropdownMenuItem<TimeOfDay>(
    value: TimeOfDay(hour: 0, minute: 15),
    child: Text('15 мин'),
  ),
];
