import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int id;
  String name;
  int n;
  int gradeid;
  int uberid;
  String degree;
  int gradenum;
  int groupnum;

  Group(
      {this.id,
      this.name,
      this.n,
      this.gradeid,
      this.uberid,
      this.degree,
      this.gradenum,
      this.groupnum});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  ///Only for teachers
  String asString() {
    if (gradenum == null || groupnum == null || name == null) {
      return "";
    }
    return '$gradenum.$groupnum ($name)';
  }
}
