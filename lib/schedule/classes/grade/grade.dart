part 'grade.g.dart';

class Grade {
  int id;
  int n;
  String degree;

  Grade({this.id, this.n, this.degree});

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
  Map<String, dynamic> toJson() => _$GradeToJson(this);
}
