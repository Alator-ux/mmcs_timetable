part of 'lesson.dart';

Lesson _$LessonFromJson(Map<String, dynamic> json, int groupID) {
  String jsonTime = json['timeslot'] as String;
  String begin = jsonTime.substring(3, 8);
  String end = jsonTime.substring(12, 17);
  int indOfDay = int.parse(jsonTime[1]);
  if (indOfDay > 5) {
    print(begin);
  }
  print(end);
  IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
  String tweek = jsonTime.substring(21, jsonTime.length - 1);
  return Lesson(
    time: _time,
    day: indOfDay,
    id: json['id'] as int,
    groupid: groupID,
    typeOfWeek: tweek,
  );
}

Lesson _$LessonFromJsonFromDB(Map<String, dynamic> json) {
  String jsonTime = json['time'] as String;
  String begin = jsonTime.substring(0, 5);
  String end = jsonTime.substring(8, 13);
  int indOfDay = json['day'] as int;
  IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
  return Lesson(
    time: _time,
    day: indOfDay,
    id: json['id'] as int,
    groupid: json['groupid'] as int,
    typeOfWeek: json['typeOfWeek'] as String,
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) {
  String time = instance.time.asString();
  return {
    'time': time,
    'day': instance.day,
    'id': instance.id,
    'groupid': instance.groupid,
    'typeOfWeek': instance.typeOfWeek,
  };
}
