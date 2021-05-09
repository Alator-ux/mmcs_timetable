import '../time.dart';
part 'lesson.g.dart';

class Lesson {
  int id;
  int groupid;
  int uberid;
  IntervalOfTime time;
  int day;
  String typeOfWeek;
  Lesson(
      {this.time,
      this.day,
      this.id,
      this.groupid,
      this.typeOfWeek,
      this.uberid});

  factory Lesson.fromJson(Map<String, dynamic> json, int groupID) =>
      _$LessonFromJson(json, groupID);

  factory Lesson.fromJsonFromDB(Map<String, dynamic> json) =>
      _$LessonFromJsonFromDB(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
