import 'package:json_annotation/json_annotation.dart';

part 'grade.g.dart';

@JsonSerializable()
class Grade {
  int id;
  int n;
  String degree;

  Grade({this.id, this.n, this.degree});

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
  Map<String, dynamic> toJson() => _$GradeToJson(this);
}
