class LessonExceptions implements Exception {
  String cause;
  LessonExceptions(this.cause);
}

class SubjectNameExcteption implements LessonExceptions {
  String cause;
  SubjectNameExcteption(this.cause);
}

class RoomNumberException implements Exception {
  String cause;
  RoomNumberException(this.cause);
}

class WeekList implements Exception {
  String cause;
}
