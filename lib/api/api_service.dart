import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:schedule/schedule/classes/import_classes.dart';
import 'package:schedule/schedule/classes/teacher/teacher.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://schedule.sfedu.ru/")
abstract class RestClient {
  static RestClient _instance;
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static RestClient create() {
    final dio = Dio();
    _instance ??= RestClient(dio);
    return _instance;
  }

  @GET("/APIv1/grade/list")
  Future<List<Grade>> getGrades();

  @GET("/APIv0/group/list/{gradeID}")
  Future<List<Group>> getGroups(@Path("gradeID") int gradeID);

  @GET("APIv0/group/forUber/{uberID}")
  Future<List<Group>> getUberGroups(@Path("uberID") int uberID);

  @GET("APIv0/schedule/lesson/{lessonID}")
  Future<Schedule> getCurricula(@Path("lessonID") int lessonID);

  @GET("APIv0/schedule/group/{groupID}")
  Future<Schedule> getSchedule(@Path("groupID") int groupID);

  @GET("APIv0/teacher/list")
  Future<List<Teacher>> getTeachers();

  @GET("APIv1/schedule/teacher/{teacherID}")
  Future<Schedule> getScheduleOfTeacher(@Path("teacherID") int teacherID);

  @GET("APIv0/time/week")
  Future<int> getCurrentWeek();
}
