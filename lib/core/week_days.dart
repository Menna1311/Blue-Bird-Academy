import 'package:easy_localization/easy_localization.dart';

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekDayX on WeekDay {
  /// Stable key used in DB & logic
  String get key => name; // monday, tuesday ...

  /// Localized label for UI
  String label() => key.tr();

  static WeekDay fromDateTime(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return WeekDay.monday;
      case DateTime.tuesday:
        return WeekDay.tuesday;
      case DateTime.wednesday:
        return WeekDay.wednesday;
      case DateTime.thursday:
        return WeekDay.thursday;
      case DateTime.friday:
        return WeekDay.friday;
      case DateTime.saturday:
        return WeekDay.saturday;
      case DateTime.sunday:
        return WeekDay.sunday;
      default:
        return WeekDay.monday;
    }
  }
}
