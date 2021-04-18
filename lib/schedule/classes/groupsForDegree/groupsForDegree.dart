/*import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule/classes/group/group.dart';

part 'groupsForDegree.g.dart';

@JsonSerializable()
class GroupsForDegree {
  int id;
  List<Group> groups;

  GroupsForDegree({this.id, this.groups});

  factory GroupsForDegree.fromJson(Map<String, dynamic> json) =>
      _$GroupsForDegreeFromJson(json);
  Map<String, dynamic> toJson() => _$GroupsForDegreeToJson(this);

  Map<String, dynamic> toJson1() {
    List<Map> jsonGroups =
        groups != null ? groups.map((i) => i.toJson()).toList() : null;
    return {
      'id': id,
      'groups': jsonGroups,
    };
  }
}*/
