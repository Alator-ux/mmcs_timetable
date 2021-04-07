// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json, int groupID) {
  return Schedule(
    lessons: (json['lessons'] as List)
        ?.map((e) => e == null
            ? null
            : Lesson.fromJson(e as Map<String, dynamic>, groupID))
        ?.toList(),
    curricula: (json['curricula'] as List)
        ?.map((e) =>
            e == null ? null : Curricula.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'lessons': instance.lessons,
      'curricula': instance.curricula,
    };
