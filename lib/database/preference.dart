import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

/*class Preference {
  final String course;
  final String group;
  Preference(this.course,this.group);
  Preference.fromJson(Map<String, dynamic> json) : course = json['course'], group = json['group'];
  Map<String, dynamic> toJson() =>
    {
      'course': course,
      'group': group,
    };
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<io.File> get _localFile async {
    final path = await _localPath;
    return io.File('$path/prefs.json');
  }

  Future<io.File> write(String s) async {
    final file = await _localFile;

    // Write the file.
    return file..writeAsString('$s');
  }

  void read() async {
    try {
      final file = await _localFile;
      var list = await file.readAsString();
    } catch (e) {
      return null;
    }
  }
}*/
