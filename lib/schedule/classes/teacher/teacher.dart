import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher {
  int id;
  String name;

  Teacher({this.id, this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
