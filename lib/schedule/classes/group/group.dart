import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule/classes/import_classes.dart';

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

  bool isEqual(Group other) {
    var res = true;
    res = res && id == other.id;
    res = res && name == other.name;
    res = res && n == other.n;
    res = res && gradeid == other.gradeid;
    res = res && uberid == other.uberid;
    res = res && degree == other.degree;
    res = res && gradenum == other.gradenum;
    res = res && groupnum == other.groupnum;
    return res;
  }

  factory Group.copy(Group copyFrom) {
    return Group(
      degree: copyFrom.degree,
      id: copyFrom.id,
      gradeid: copyFrom.gradeid,
      n: copyFrom.n,
      groupnum: copyFrom.groupnum,
      gradenum: copyFrom.gradenum,
      name: copyFrom.name,
      uberid: copyFrom.uberid,
    );
  }

  static List<Group> groupsFromString(String groupsAsString, int uberid) {
    List<Group> res = [];
    if (groupsAsString == "") {
      return res;
    }
    var groupsAsStrings = groupsAsString.split(',');
    for (var groupAsString in groupsAsStrings) {
      if (groupAsString == "") {
        continue;
      }
      groupAsString = groupAsString.replaceAll(' ', '');
      var gradenum = int.parse(groupAsString[0]);
      var firstBracketInd = groupAsString.indexOf('(');
      var groupnum = int.parse(groupAsString.substring(1, firstBracketInd));
      var secondBracketInd = groupAsString.indexOf(')');
      var name = groupAsString.substring(firstBracketInd + 1, secondBracketInd);
      var newGroup = Group(
          degree: '',
          gradeid: 0,
          gradenum: gradenum,
          groupnum: groupnum,
          id: 0,
          n: 0,
          name: name,
          uberid: uberid);
      res.add(newGroup);
    }
    return res;
  }
}
