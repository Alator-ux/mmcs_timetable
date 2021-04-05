// import 'package:json_annotation/json_annotation.dart';
// import 'time.dart';
// // import 'package:flutter/cupertino.dart';

// //@JsonSerializable()
// class Lesson {
//   int id;
//   int uberid;
//   IntervalOfTime time;
//   Lesson({this.time, this.id, this.uberid});

//   // Lesson.withTimeFromString(
//   //     {@required String time, @required int id, @required int uberid}) {
//   //   var td1 = IntervalOfTime.timeOfDayFromString(time.substring(0, 5));
//   //   var td2 = IntervalOfTime.timeOfDayFromString(time.substring(6, 11));

//   //   this.time = ''; //IntervalOfTime(td1, td2);
//   //   this.id = id;
//   //   this.uberid = uberid;
//   // }

//   factory Lesson.fromJson(Map<String, dynamic> json) {
//     String jsonTime = json['timeslot'];
//     String begin = jsonTime.substring(3, 8);
//     String end = jsonTime.substring(12, 17);
//     print(begin);
//     print(end);
//     IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
//     return Lesson(
//       time: _time,
//       id: json['id'] as int,
//       uberid: json['uberid'] as int,
//     );
//   }

//   factory Lesson.fromJsonFromDB(Map<String, dynamic> json) {
//     String jsonTime = json['time'];
//     String begin = jsonTime.substring(0, 4);
//     String end = jsonTime.substring(5, 9);
//     IntervalOfTime _time = IntervalOfTime.fromString(begin, end);
//     return Lesson(
//       time: _time,
//       id: json['id'] as int,
//       uberid: json['uberid'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     String time = this.time.asString();
//     return {
//       'id': id,
//       'uberid': uberid,
//       'time': time,
//     };
//   }
//   /*IntervalOfTime get time => _time;

//   String get subject => _subject;

//   String get room => _room;

//   set time(IntervalOfTime time) {
//     this._time = time;
//   }

//   set subject(String subject) {
//     if (subject.length < 2)
//       throw SubjectNameExcteption("Subject title is too short");
//     this._subject = subject;
//   }

//   set room(String room) {
//     var n = int.tryParse(room);
//     if (n < 1)
//       throw RoomNumberException("number of room can not be less than one");
//     this._room = room;
//   }*/
// }
