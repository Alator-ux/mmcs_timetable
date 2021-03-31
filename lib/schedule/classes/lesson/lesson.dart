// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as int,
    name: json['name'] as String,
    n: json['n'] as int,
    gradeid: json['gradeid'] as int,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'n': instance.n,
      'gradeid': instance.gradeid,
    };
