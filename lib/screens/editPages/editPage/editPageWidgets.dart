import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/grade/grade.dart';
import 'package:schedule/schedule/classes/group/group.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/schedule/test_values/test_values.dart';
import 'package:schedule/screens/editPages/editModePage/editProvider.dart';
import 'package:schedule/screens/editPages/editPage/editPageProvider.dart';
import 'package:schedule/screens/widgetsHelper/widgetsHelper.dart';

import '../../../main.dart' show SizeProvider;

final TextStyle formTextStyle = TextStyle(
  fontSize: SizeProvider().getSize(0.05),
);

final InputDecoration textFormDecoration = InputDecoration(
  border: InputBorder.none,
);

final BoxDecoration wrapperDecoration = BoxDecoration(
  color: Colors.teal[50],
  borderRadius: BorderRadius.circular(10.0),
);

final TextStyle titleTextStyle = TextStyle(
    fontSize: SizeProvider().getSize(0.04), fontWeight: FontWeight.bold);

typedef String TextEditor(String value);
typedef String Validator(String value);
typedef Future OnTapAction(BuildContext context);
String _defaultTextEditor(String value) => value;

///TextFromField wrapper
class TFFWrapper extends StatefulWidget {
  final String title;
  final String subTitle;
  // final TextEditor onChanged;
  final Validator validator;
  final String initialValue;
  final TextInputType keyboardType;
  final OnTapAction onTap;
  final bool readOnly;
  final AutovalidateMode autovalidateMode;
  final Key textFormFieldKey;

  ///Create TextFromField wrapper
  TFFWrapper(
      {Key key,
      this.textFormFieldKey,
      this.title = '',
      this.subTitle = '',
      this.validator,
      this.initialValue = '',
      this.onTap,
      // this.onChanged = _defaultTextEditor,
      this.readOnly = false,
      this.keyboardType = TextInputType.text,
      this.autovalidateMode = AutovalidateMode.always})
      : super(key: key);

  @override
  _TFFWrapperState createState() => _TFFWrapperState();
}

class _TFFWrapperState extends State<TFFWrapper> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if ((widget.onTap == null) ^ (widget.readOnly == false)) {
      throw Exception('\'onTap == null || readOnly == null\' is not true');
    }
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      final String text = _controller.text;
      _controller.value = _controller.value.copyWith(
        text: text,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.title;
    var subTitle = widget.subTitle;
    return Column(
      children: [
        subTitle == ''
            ? Center(
                child: Text(
                  title,
                  style: titleTextStyle,
                ),
              )
            : Center(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: titleTextStyle,
                    ),
                    Text(
                      subTitle,
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),
        Container(
          decoration: wrapperDecoration,
          child: TextFormField(
            onTap: () async {
              var onTap = widget.onTap;
              if (onTap != null) {
                var res = await widget.onTap(context);
                if (res is IntervalOfTime) {
                  _controller.text = res.asString().replaceAll(' ', '');
                } else if (res is List<Group>) {
                  _controller.text = Group.groupsAsString(res);
                }
              }
            },
            key: widget.textFormFieldKey,
            readOnly: widget.readOnly,
            controller: _controller,
            textAlign: TextAlign.center,
            autovalidateMode: widget.autovalidateMode,
            validator: widget.validator,
            decoration: textFormDecoration,
            keyboardType: widget.keyboardType,
            style: formTextStyle,
          ),
        ),
      ],
    );
  }
}

List<String> _hours() {
  List<String> res = [];
  for (int i = 8; i < 10; i++) {
    res.add('0' + i.toString());
  }
  for (int i = 10; i < 22; i++) {
    res.add(i.toString());
  }
  return res;
}

List<String> _minutes() {
  List<String> res = [];
  for (int i = 0; i < 10; i += 5) {
    res.add('0' + i.toString());
  }
  for (int i = 10; i < 60; i += 5) {
    res.add(i.toString());
  }
  return res;
}

///showTimeModalBottomSheet
Future<IntervalOfTime> showTimeMBS(BuildContext context) {
  var tStyle = TextStyle(fontSize: 30);
  return showModalBottomSheet<IntervalOfTime>(
      enableDrag: true,
      backgroundColor: Colors.grey[50],
      context: context, //
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TimeListWheelScrollView(
                  items: _hours(),
                  timeType: TimeType.beginHour,
                ),
                Text(
                  ':',
                  style: tStyle,
                ),
                TimeListWheelScrollView(
                  items: _minutes(),
                  timeType: TimeType.beginMinute,
                ),
                Text(
                  '-',
                  style: tStyle,
                ),
                TimeListWheelScrollView(
                  items: _hours(),
                  timeType: TimeType.endHour,
                ),
                Text(
                  ':',
                  style: tStyle,
                ),
                TimeListWheelScrollView(
                  items: _minutes(),
                  timeType: TimeType.endMinute,
                ),
              ],
            ),
            CustomButton(
              child: Center(
                child: Text(
                  'Выбрать',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                Navigator.pop(context, ModalBottomSheetController().time);
              },
            ),
          ],
        );
      });
}

class TimeListWheelScrollView extends StatefulWidget {
  final List<String> items;
  final TextStyle textStyle;
  final TimeType timeType;
  TimeListWheelScrollView(
      {@required this.items,
      @required this.timeType,
      this.textStyle = const TextStyle(fontSize: 15)});

  @override
  _TimeListWheelScrollViewState createState() =>
      _TimeListWheelScrollViewState();
}

class _TimeListWheelScrollViewState extends State<TimeListWheelScrollView> {
  String selectedItem;
  ModalBottomSheetController controller;
  @override
  void initState() {
    super.initState();
    selectedItem = widget.items.first;
    controller = ModalBottomSheetController();
    controller.timeAsStrings[widget.timeType.index] =
        selectedItem; //Ужас но что поделать
  }

  void changeItem(int index) {
    selectedItem = widget.items[index];
    controller.timeAsStrings[widget.timeType.index] =
        selectedItem; //Ужас но что поделать
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.items;
    return Container(
      width: SizeProvider().getSize(0.2),
      height: SizeProvider().getSize(0.4, from: SizeFrom.height),
      child: ListWheelScrollView.useDelegate(
        physics: BouncingScrollPhysics(),
        diameterRatio: 1,
        itemExtent: SizeProvider().getSize(0.08, from: SizeFrom.height),
        useMagnifier: true,
        magnification: 1.5,
        onSelectedItemChanged: changeItem,
        childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              return Container(
                width: SizeProvider().getSize(0.5),
                height: SizeProvider()
                    .getSize(0.00003, from: SizeFrom.height), //TODO what
                child: Center(
                  child: Text(items[index], style: widget.textStyle),
                ),
              );
            },
            childCount: items.length),
      ),
    );
  }
}

///showTimeModalBottomSheet
Future<List<Group>> showGroupsMBS(BuildContext context) async {
  var provider = GroupProvider();
  await showModalBottomSheet<List<Group>>(
    enableDrag: true,
    backgroundColor: Colors.grey[50],
    context: context, //
    builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
        value: provider,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DDButtons(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      width: SizeProvider().getSize(0.4),
                      child: Text(
                        'Стереть все',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        provider.deleteGroups();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Группы стерты'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    CustomButton(
                      width: SizeProvider().getSize(0.4),
                      child: Text(
                        'Добавить',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        var added = provider.addGroup();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(added
                                ? 'Группа добавлена'
                                : 'Группа уже добавлена'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
  return provider.groups;
}

class DDButtons extends StatefulWidget {
  @override
  _DDButtonsState createState() => _DDButtonsState();
}

class _DDButtonsState extends State<DDButtons> {
  List<DropdownMenuItem<Grade>> _gradeItems;
  List<DropdownMenuItem<Group>> _groupItems;
  GroupProvider provider;
  bool changedGrade = false;

  void update() {
    _groupItems = editPageGroupItems(provider.curGrade);
    if (changedGrade) {
      provider.curGroup = _groupItems.first.value;
      changedGrade = false;
    }
  }

  @override
  void initState() {
    _gradeItems = editPageGradeItems();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<GroupProvider>(context);
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<Grade>(
          isExpanded: true,
          items: _gradeItems,
          value: provider.curGrade,
          onChanged: (value) {
            changedGrade = true;
            provider.changeGrade(value);
          },
        ),
        DropdownButton<Group>(
          isExpanded: true,
          items: _groupItems,
          value: provider.curGroup,
          onChanged: (value) {
            provider.changeGroup(value);
          },
        ),
      ],
    );
  }
}
