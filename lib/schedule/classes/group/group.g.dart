// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as int,
    name: json['name'] as String,
    n: json['num'] as int,
    gradeid: json['gradeid'] as int,
    uberid: json['uberid'] as int,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'num': instance.n,
      'gradeid': instance.gradeid,
      'uberid': instance.uberid,
    };
