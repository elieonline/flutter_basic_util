import 'package:intl/intl.dart';

extension ToDateTime on DateTime? {
  String get toDateTime => (this == null) ? "" : DateFormat('MMM d y hh:mm a').format(this!);
  String get toTime => (this == null) ? "" : DateFormat('hh:mm').format(this!);
  String get toTime12 => (this == null) ? "" : DateFormat('hh:mm a').format(this!);

  String get toDate => (this == null)
      ? ""
      : "${DateFormat.d().format(this!)}${getDayOfMonthSuffix(this!.day)} ${DateFormat('MMM, y').format(this!)}";
  String get toMonthDate =>
      (this == null) ? "" : "${DateFormat('MMMM d').format(this!)}${getDayOfMonthSuffix(this!.day)}";
  String get toDateTimeYear => (this == null) ? "" : DateFormat('EEE, MMM d y hh:mm a').format(this!);
  String get toDayDateTimeYear => (this == null) ? "" : DateFormat('MMM d, y').format(this!);

  String get toDateMonthYearTime => (this == null) ? "" : DateFormat('dd/MM/yyyy hh:mm a').format(this!);
  String get toSlashDate => (this == null) ? "" : DateFormat('dd/MM/yyyy').format(this!);
  String get toDashDate => (this == null) ? "" : DateFormat('dd-MM-yyyy').format(this!);
  String get toDashDate2 => (this == null) ? "" : DateFormat('dd-MMM-yyyy').format(this!);
  String get toDashDateTime => (this == null) ? "" : DateFormat('dd-MM-yyyy | hh:mm a').format(this!);
  String get toFilterDate => (this == null) ? "" : DateFormat('dd MMM, yy').format(this!);
  String get toDay => (this == null) ? "" : DateFormat('dd').format(this!);
  String get toMonth => (this == null) ? "" : DateFormat.MMMM().format(this!);
  String get toYear => (this == null) ? "" : DateFormat.y().format(this!);
  String get toMonthYear => (this == null) ? "" : DateFormat('MMMM, y').format(this!);
  int get toWeek => (this == null) ? 0 : getIsoWeekNumber(this!);
}

String getDayOfMonthSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

int getIsoWeekNumber(DateTime date) {
  // Get the Thursday of the current week (ISO week starts near the closest Thursday)
  DateTime thursdayOfCurrentWeek = date.add(Duration(days: (4 - date.weekday)));

  // Get January 4th of the year (since ISO weeks always start around this date)
  DateTime firstThursdayOfYear = DateTime(thursdayOfCurrentWeek.year, 1, 4);

  // Find the Thursday of the first week of the year
  DateTime firstWeekThursday = firstThursdayOfYear.add(Duration(days: (4 - firstThursdayOfYear.weekday)));

  // Calculate the difference in days between the current week's Thursday and the year's first week Thursday
  int weekNumber = ((thursdayOfCurrentWeek.difference(firstWeekThursday).inDays) ~/ 7) + 1;

  return weekNumber;
}
