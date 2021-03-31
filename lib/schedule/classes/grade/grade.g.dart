// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) {
  return Grade(
    id: json['id'] as int,
    n: json['n'] as int,
    degree: json['degree'] as String,
  );
}

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'id': instance.id,
      'n': instance.n,
      'degree': instance.degree,
    };
