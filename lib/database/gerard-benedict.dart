import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/schedule/classes/groupsForDegree/groupsForDegree.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:schedule/schedule/classes/import_classes.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();
  static Database _database;
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory(); //
    String path = join(documentsDirectory.path, "scheduleDB4.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Grade ("
          "id INTEGER PRIMARY KEY,"
          "num INTEGER,"
          "degree TEXT"
          ")");
      await db.execute("CREATE TABLE AllGroups ("
          "id INTEGER PRIMARY KEY,"
          "groups TEXT"
          ")");
      await db.execute("CREATE TABLE Map ("
          "id INTEGER PRIMARY KEY,"
          "schedule TEXT"
          ")");
    });
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

  newAllGroups(GroupsForDegree groups) async {
    final db = await database;
    var res = await db.insert("AllGroups", groups.toJson());
    return res;
  }

  Future<List<GroupsForDegree>> getAllGroups() async {
    final db = await database;
    var res = await db.query("AllGroups");
    List<GroupsForDegree> list = res.isNotEmpty
        ? res.map((c) => GroupsForDegree.fromJson(c)).toList()
        : [];
    return list;
  }

  newSchedule(int id, Schedule schedule) async {
    final db = await database;
    var res = await db.rawInsert("INSERT Into Map (id,schedule)"
        " VALUES (${id},${schedule.toJson()})");
    return res;
  }

  Future<Map<int, Schedule>> getMap() async {
    final db = await database;
    var tempres = await db
        .query("SELECT id FROM Map"); // "SELECT MAX(id)+1 as id FROM Client"
    List<int> list1 =
        tempres.isNotEmpty ? tempres.map((c) => c as int).toList() : [];

    tempres = await db.query(
        "SELECT schedule FROM Map"); // "SELECT MAX(id)+1 as id FROM Client"
    List<Schedule> list2 = tempres.isNotEmpty
        ? tempres.map((c) => Schedule.fromJson(c)).toList()
        : [];

    var res = Map<int, Schedule>();
    for (int i = 0; i < list1.length; i++) {
      res[list1[i]] = list2[i];
    }
    return res;
  }

  fillGradeTable(List<Grade> grades) {
    grades.forEach((grade) {
      newGrade(grade);
    });
  }

  fillAllGroupTable(List<List<Group>> allgroups) {
    List<GroupsForDegree> groupsForDegree = [];
    int i = 0;
    allgroups.forEach(
      (groups) {
        var gfd = GroupsForDegree(groups: groups, id: i);
        groupsForDegree.add(gfd);
        i++;
      },
    );
    groupsForDegree.forEach(
      (groups) {
        newAllGroups(groups);
      },
    );
  }

  fillMapTable(Map<int, Schedule> schedules) {
    schedules.forEach(
      (id, schedule) {
        newSchedule(id, schedule);
      },
    );
  }
}

// Future<Grade> getGrade(int id) async {
//   final db = await database;
//   var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
//   return res.isNotEmpty ? Client.fromJson(res.first) : Null;
// }
