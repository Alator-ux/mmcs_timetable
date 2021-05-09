import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int id;
  String name;
  int n;
  int gradeid;
  int uberid;

  Group({this.id, this.name, this.n, this.gradeid, this.uberid});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
