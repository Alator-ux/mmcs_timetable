import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule/classes/curricula/curricula.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';
import '../lesson.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  List<Lesson> lessons;
  List<Curricula> curricula;

  Schedule({this.lessons, this.curricula});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
