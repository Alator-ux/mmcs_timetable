part 'group.g.dart';

class Group {
  int id;
  String name;
  int n;
  int gradeid;

  Group({this.id, this.name, this.n, this.gradeid});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
