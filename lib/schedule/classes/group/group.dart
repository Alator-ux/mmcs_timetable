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
    if (gradenum == null || (groupnum == null && n == null) || name == null) {
      return "";
    }
    int t;
    if (groupnum == null) {
      t = n;
    } else {
      t = groupnum;
    }
    return '$gradenum.$t';
  }

  static int compareGroups(Group gr1, Group gr2) {
    if (gr1.gradenum > gr2.gradenum) {
      return 1;
    }
    if (gr1.gradenum == gr2.gradenum) {
      if (gr1.groupnum > gr2.groupnum) {
        return 1;
      } else {
        return -1;
      }
    }
    return -1;
  }

  bool isEqual(Group other) {
    var res = true;
    res = res && id == other.id;
    res = res && name == other.name;
    res = res && n == other.n;
    res = res && gradeid == other.gradeid;
    return res;
  }

  bool isEqualFroNotPrimitive(Group other) {
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
      var groupnum = int.parse(groupAsString.substring(2, firstBracketInd));
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

  static String groupsAsString(List<Group> groups) {
    String res = "";
    if (groups == null || groups.length == 0) {
      return res;
    }
    for (var groupID = 0; groupID < groups.length - 1; groupID++) {
      var groupAsString = groups[groupID].asString();
      res += '$groupAsString, ';
    }
    var groupAsString = groups[groups.length - 1].asString();
    res += '$groupAsString';
    return res;
  }
}
