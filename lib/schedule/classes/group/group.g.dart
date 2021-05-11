// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    degree: json['degree'] as String,
    gradenum: json['gradenum'] as int,
    groupnum: json['groupnum'] as int,
    uberid: json['uberid'] as int,
    gradeid: json['gradeid'] as int,
    id: json['id'] as int,
    n: json['num'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'degree': instance.degree,
      'gradenum': instance.gradenum,
      'groupnum': instance.groupnum,
      'uberid': instance.uberid,
      'gradeid': instance.gradeid,
      'id': instance.id,
      'num': instance.n,
      'name': instance.name,
    };
