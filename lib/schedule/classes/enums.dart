import 'package:schedule/main.dart' show MainPage;
import 'package:schedule/screens/displayPages/DayPage.dart' show DayPage;

enum TypeOfWeek { lower, upper }

extension ToWConverter on TypeOfWeek {
  String asString() {
    switch (this) {
      case TypeOfWeek.upper:
        return "Верхняя";
      case TypeOfWeek.lower:
        return "Нижняя";
    }
    return "";
  }

  String toJsonString() {
    switch (this) {
      case TypeOfWeek.upper:
        return "upper";
      case TypeOfWeek.lower:
        return "lower";
    }
    return "";
  }
}

TypeOfWeek typeOfWeekFromString(String typeOfWeek) {
  switch (typeOfWeek) {
    case "upper":
      return TypeOfWeek.upper;
    case "lower":
      return TypeOfWeek.lower;
  }
  return TypeOfWeek.lower;
}

enum DaysOfWeek { mon, tue, wed, thr, fri, sat, sun }

extension DWConverter on DaysOfWeek {
  String asString() {
    switch (this) {
      case DaysOfWeek.mon:
        return "Понедельник";
      case DaysOfWeek.tue:
        return "Вторник";
      case DaysOfWeek.wed:
        return "Среда";
      case DaysOfWeek.thr:
        return "Четверг";
      case DaysOfWeek.fri:
        return "Пятница";
      case DaysOfWeek.sat:
        return "Суббота";
      case DaysOfWeek.sun:
        return "Воскресенье";
    }
    return "";
  }
}

enum UserType { student, teacher }

extension UTConverter on UserType {
  String asString() {
    switch (this) {
      case UserType.student:
        return "Студент";
      case UserType.teacher:
        return "Преподаватель";
    }
    return "";
  }
}

enum SizeFrom { width, height }

enum ScreenRoute { mainPage, displayPage }

ScreenRoute screenRouteFromString(String route) {
  switch (route) {
    case MainPage.routeName:
      return ScreenRoute.mainPage;
    case DayPage.routeName:
      return ScreenRoute.displayPage;
  }
  return ScreenRoute.mainPage;
}

enum TimeType { beginHour, beginMinute, endHour, endMinute }
