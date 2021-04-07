// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curricula.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Curricula _$CurriculaFromJson(Map<String, dynamic> json) {
  return Curricula(
    id: json['id'] as int,
    lessonid: json['lessonid'] as int,
    subjectname: json['subjectname'] as String,
    subjectabbr: json['subjectabbr'] as String,
    teacherid: json['teacherid'] as int,
    teachername: json['teachername'] as String,
    roomid: json['roomid'] as int,
    roomname: json['roomname'] as String,
  );
}

Map<String, dynamic> _$CurriculaToJson(Curricula instance) => <String, dynamic>{
      'id': instance.id,
      'lessonid': instance.lessonid,
      'subjectname': instance.subjectname,
      'subjectabbr': instance.subjectabbr,
      'teacherid': instance.teacherid,
      'teachername': instance.teachername,
      'roomid': instance.roomid,
      'roomname': instance.roomname,
    };
