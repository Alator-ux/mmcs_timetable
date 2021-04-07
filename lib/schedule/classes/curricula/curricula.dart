import 'package:json_annotation/json_annotation.dart';

part 'curricula.g.dart';

@JsonSerializable()
class Curricula {
  int id;
  int lessonid;
  String subjectname;
  String subjectabbr;
  int teacherid;
  String teachername;
  int roomid;
  String roomname;
  Curricula(
      {this.id,
      this.lessonid,
      this.subjectname,
      this.subjectabbr,
      this.teacherid,
      this.teachername,
      this.roomid,
      this.roomname}) {
    /*this._id = id;
    this._lessonid = lessonID;
    this._subjectid = subjectID;
    this._subjectname = subjectName;
    this._subjectabbr = subjectAbbr;
    this._teacherid = teacherID;
    this._roomid = roomID;*/
  }

  factory Curricula.fromJson(Map<String, dynamic> json) =>
      _$CurriculaFromJson(json);
  Map<String, dynamic> toJson() => _$CurriculaToJson(this);
}
