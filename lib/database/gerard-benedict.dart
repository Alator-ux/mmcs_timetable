import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/schedule/classes/curricula/curricula.dart';
import 'package:schedule/schedule/classes/groupsForDegree/groupsForDegree.dart';
import 'package:schedule/schedule/classes/lesson/lesson.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:schedule/schedule/test_values/test_values.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:schedule/schedule/classes/import_classes.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();
  static Database _database;
  final String dbname = "schedule112.db";
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory(); //
    String path = join(documentsDirectory.path, dbname);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Grade ("
          "id INTEGER,"
          "num INTEGER,"
          "degree TEXT"
          ")");
      await db.execute("CREATE TABLE AllGroups ("
          "id INTEGER,"
          "name TEXT,"
          "num INTEGER,"
          "gradeid INTEGER"
          ")");
      await db.execute("CREATE TABLE Lesson ("
          "id INTEGER,"
          "groupid INTEGER,"
          "time Text,"
          "day Integer,"
          "typeOfWeek Text"
          ")");
      await db.execute("CREATE TABLE Curricula ("
          "id INTEGER,"
          "lessonid INTEGER,"
          "subject INTEGER,"
          "subjectname Text,"
          "subjectabbr Text,"
          "teacherid INTEGER,"
          "teachername Text,"
          "roomid INTEGER,"
          "roomname Text"
          ")");
      await db.execute("CREATE TABLE NormalLesson ("
          "lessonid INTEGER,"
          "groupid INTEGER,"
          "typeOfWeek Text,"
          "dayid INTEGER,"
          "time Text,"
          "subjectname Text,"
          "subjectabbr Text,"
          "teachername Text,"
          "roomname Text"
          ")");
    });
  }

  newNormalLesson(NormalLesson normalLesson) async {
    final db = await database;
    var res = await db.insert("NormalLesson", normalLesson.toJson());
    return res;
  }

  Future<List<NormalLesson>> _getNormalLessons() async {
    final db = await database;
    var res = await db.query("NormalLesson");
    List<NormalLesson> list =
        res.isNotEmpty ? res.map((c) => NormalLesson.fromJson(c)).toList() : [];
    return list;
  }

  newLesson(Lesson lesson) async {
    final db = await database;
    var res = await db.insert("Lesson", lesson.toJson());
    return res;
  }

  Future<List<Lesson>> _getLessons() async {
    final db = await database;
    var res = await db.query("Lesson");
    List<Lesson> list =
        res.isNotEmpty ? res.map((c) => Lesson.fromJsonFromDB(c)).toList() : [];
    return list;
  }

  newCurricula(Curricula curricula) async {
    final db = await database;
    var res = await db.insert("Curricula", curricula.toJson());
    return res;
  }

  Future<List<Curricula>> _getCurricula() async {
    final db = await database;
    var res = await db.query("Curricula");
    List<Curricula> list =
        res.isNotEmpty ? res.map((c) => Curricula.fromJson(c)).toList() : [];
    return list;
  }

  newGrade(Grade newGrade) async {
    final db = await database;
    var res = await db.insert("Grade", newGrade.toJson());
    return res;
  }

  Future<List<Grade>> getAllGrades() async {
    final db = await database;
    var res = await db.query("Grade");
    List<Grade> list =
        res.isNotEmpty ? res.map((c) => Grade.fromJson(c)).toList() : [];
    return list;
  }

  newAllGroups(Group group) async {
    final db = await database;
    var res = await db.insert("AllGroups", group.toJson());
    return res;
  }

  Future<List<Group>> _getAllGroups() async {
    final db = await database;
    var res = await db.query("AllGroups");
    List<Group> list =
        res.isNotEmpty ? res.map((c) => Group.fromJson(c)).toList() : [];
    return list;
  }

  Future<Map<int, Schedule>> getMap() async {
    var lessons = await _getLessons();
    var curricula = await _getCurricula();
    var groupid = lessons.map((lesson) => lesson.groupid);
    var res = Map<int, Schedule>();
    groupid.forEach(
      (id) {
        var lessonsWithID =
            lessons.where((lesson) => lesson.groupid == id).toList();
        List<Curricula> tempCurricula = [];
        lessonsWithID.forEach(
          (lesson) {
            var cur = curricula.firstWhere((c) => c.lessonid == lesson.id);
            tempCurricula.add(cur);
          },
        );
        var schedule =
            Schedule(lessons: lessonsWithID, curricula: tempCurricula);
        res[id] = schedule;
      },
    );

    return res;
  }

  Future<List<Week>> getWeeks(int groupid) async {
    var normalLessons = await _getNormalLessons();
    var lessons = normalLessons.where((lesson) => lesson.groupid == groupid);
    List<Week> res = [Week.fromDB(), Week.fromDB()];
    var lowerlessons = lessons.where((lesson) => lesson.typeOfWeek == "lower");
    var upperlessons = lessons.where((lesson) => lesson.typeOfWeek == "upper");
    for (int i = 0; i < 7; i++) {
      var lowdaylessons =
          lowerlessons.where((lesson) => lesson.dayid == i).toList();
      lowdaylessons.sort(
        (l1, l2) => IntervalOfTime.compare(l1.time, l2.time),
      );

      var updaylessons =
          upperlessons.where((lesson) => lesson.dayid == i).toList();
      updaylessons.sort(
        (l1, l2) => IntervalOfTime.compare(l1.time, l2.time),
      );
      res[0].days[i].normalLessons = lowdaylessons;
      res[1].days[i].normalLessons = updaylessons;
    }
    return res;
  }

  Future<List<List<Group>>> getAllGroups(List<int> gradeid) async {
    var allgroups = await _getAllGroups();
    // var listid = await _getAllGroups();
    // print(groups.length);
    // print(id.length);
    List<List<Group>> res = [];
    gradeid.forEach(
      (id) {
        var groups = allgroups.where((group) => group.gradeid == id).toList();
        res.add(groups);
      },
    );
    return res;
  }

  Future<bool> refreshDb() async {
    bool databaseDeleted = false;

    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, dbname);
      await deleteDatabase(path).whenComplete(() {
        databaseDeleted = true;
      }).catchError((onError) {
        databaseDeleted = false;
      }).whenComplete(
        () async {
          _database = await initDB();
        },
      );
    } on DatabaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }

    return databaseDeleted;
  }

  fillGradeTable(List<Grade> grades) async {
    await Future.forEach(
      grades,
      (grade) async {
        await newGrade(grade);
      },
    );
  }

  fillAllGroupTable(List<List<Group>> allgroups) async {
    await Future.forEach(
      allgroups,
      (groups) async {
        await Future.forEach(
          groups,
          (group) async {
            await newAllGroups(group);
          },
        );
      },
    );
  }

  fillSchedule(Map<int, Schedule> schedules) async {
    await Future.forEach(
      schedules.keys,
      (groupid) async {
        await Future.forEach(
          schedules[groupid].lessons,
          (lesson) async {
            await newLesson(lesson);
          },
        );
        await Future.forEach(
          schedules[groupid].curricula,
          (cur) async {
            await newCurricula(cur);
          },
        );
      },
    );
  }

  fillWeeks(List<Week> weeks) async {
    await Future.forEach(
      weeks,
      (week) async {
        await Future.forEach(
          week.days,
          (day) async {
            await Future.forEach(
              day.normalLessons,
              (normalLesson) async {
                await newNormalLesson(normalLesson);
              },
            );
          },
        );
      },
    );
  }
}
