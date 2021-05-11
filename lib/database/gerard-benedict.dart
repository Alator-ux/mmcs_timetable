import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/schedule/classes/enums.dart';
import 'package:schedule/schedule/classes/normalLesson/normalLesson.dart';
import 'package:schedule/schedule/classes/time.dart';
import 'package:schedule/schedule/classes/week.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:schedule/schedule/classes/import_classes.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();
  static Database _database;
  final String dbname = "schedule121.db";
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbname);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Groups ("
          "updateable INTEGER,"
          "id INTEGER,"
          "name TEXT,"
          "num INTEGER,"
          "gradeid INTEGER,"
          "uberid INTEGER,"
          "degree TEXT,"
          "gradenum INTEGER,"
          "groupnum INTEGER"
          ")");
      await db.execute("CREATE TABLE NormalLesson ("
          "updateable INTEGER,"
          "lessonid INTEGER,"
          "groupid INTEGER,"
          "uberid INTEGER,"
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

  getNormalLesson(int grId) async {
    final db = await database;
    return db.query("NormalLesson", where: ("groupid = $grId"));
  }

  getNormalLessonUber(int uberid) async {
    final db = await database;
    return db.query("NormalLesson", where: ("groupid = $uberid"));
  }

  getGroup(int grId) async {
    final db = await database;
    return db.query("Groups", where: ("groupid = $grId"));
  }

  Future<List<NormalLesson>> getNormalLessons(int updateableInd) async {
    final db = await database;
    var res =
        await db.query("NormalLesson", where: ("updateable = $updateableInd"));
    List<NormalLesson> list =
        res.isNotEmpty ? res.map((c) => NormalLesson.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Group>> getGroups(int updateableInd) async {
    final db = await database;
    var res = await db.query("Groups", where: ("updateable = $updateableInd"));
    List<Group> list =
        res.isNotEmpty ? res.map((c) => Group.fromJson(c)).toList() : [];
    return list;
  }

  getGroupUber(int uberid) async {
    final db = await database;
    return db.query("Groups", where: ("groupid = $uberid"));
  }

  newGroup(Group gr, int updInd) async {
    final db = await database;
    var json = gr.toJson();
    json['updateable'] = updInd;
    var res = await db.insert("Groups", json);
    return res;
  }

  newNormalLesson(NormalLesson normalLesson, int updInd) async {
    final db = await database;
    var json = normalLesson.toJson();
    json['updateable'] = updInd;
    var res = await db.insert("NormalLesson", json);
    return res;
  }

  refreshNormalLesson(List<NormalLesson> lessons) async {
    final db = await database;
    db.rawDelete("DELETE FROM NormalLesson WHERE id = ${1}");
    await Future.forEach(lessons, (lesson) async {
      await newNormalLesson(lesson, 1);
    });
  }

  refreshGroup(List<Group> groups) async {
    final db = await database;
    db.rawDelete("DELETE FROM Groups WHERE updateable = ${1}");
    await Future.forEach(groups, (group) async {
      await newGroup(group, 1);
    });
  }

  Future<List<Week>> getWeeksForStudent() async {
    var lessons = await getNormalLessons(1);
    if (lessons.isEmpty) {
      return [];
    }
    List<Week> res = [Week.fromDB(), Week.fromDB()];
    var lowerlessons =
        lessons.where((lesson) => lesson.typeOfWeek == TypeOfWeek.lower);
    var upperlessons =
        lessons.where((lesson) => lesson.typeOfWeek == TypeOfWeek.upper);
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

  Future<List<Week>> getWeeksForTeacher() async {
    var lessons = await getNormalLessons(1);
    var groups = await getGroups(1);
    if (lessons.isEmpty) {
      return [];
    }

    List<Group> _deleteRepetitions(List<Group> groups) {
      Set<String> groupsAsSet = Set<String>();
      List<Group> res = [];
      groups.forEach(
        (group) {
          if (!groupsAsSet.contains(group.asString())) {
            groupsAsSet.add(group.asString());
            res.add(group);
          }
        },
      );
      return res;
    }

    for (int i = 0; i < lessons.length; i++) {
      var gr =
          groups.where((group) => group.uberid == lessons[i].uberid).toList();
      gr = _deleteRepetitions(gr);
      lessons[i].groups = gr;
    }

    List<Week> res = [Week.fromDB(), Week.fromDB()];
    var lowerlessons =
        lessons.where((lesson) => lesson.typeOfWeek == TypeOfWeek.lower);
    var upperlessons =
        lessons.where((lesson) => lesson.typeOfWeek == TypeOfWeek.upper);
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
                await newNormalLesson(normalLesson, 0);
                await newNormalLesson(normalLesson, 1);
                var groups = normalLesson.groups;
                if (groups != null) {
                  await Future.forEach(groups, (group) async {
                    await newGroup(group, 0);
                    await newGroup(group, 1);
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  refreshWeeks(List<Week> weeks) async {
    final db = await database;

    db.rawDelete("DELETE FROM NormalLesson WHERE updateable = ${1}");
    db.rawDelete("DELETE FROM Groups WHERE updateable = ${1}");
    await Future.forEach(
      weeks,
      (week) async {
        await Future.forEach(
          week.days,
          (day) async {
            await Future.forEach(
              day.normalLessons,
              (normalLesson) async {
                await newNormalLesson(normalLesson, 1);
                var groups = normalLesson.groups;
                if (groups != null) {
                  await newGroup(normalLesson.groups, 1);
                }
              },
            );
          },
        );
      },
    );
  }
}
