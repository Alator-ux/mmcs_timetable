enum TypeWeek { upper, lower }

extension WeekConverter on TypeWeek {
  String asString() {
    switch (this) {
      case TypeWeek.upper:
        return "Верхняя";
      case TypeWeek.lower:
        return "Нижняя";
    }
    return "";
  }
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
