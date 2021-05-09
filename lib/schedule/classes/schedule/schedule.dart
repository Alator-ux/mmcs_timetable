import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule/classes/curricula/curricula.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  List<Lesson> lessons;
  List<Curricula> curricula;
  List<Group> groups;

  Schedule({this.lessons, this.curricula, this.groups});

  factory Schedule.fromJson(Map<String, dynamic> json, int groupID) =>
      _$ScheduleFromJson(json, groupID);

  factory Schedule.fromJsonForTeacher(Map<String, dynamic> json) =>
      _$ScheduleFromJsonForTeacher(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
