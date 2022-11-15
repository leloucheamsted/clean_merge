import 'package:intl/intl.dart';

class DateHelper {
  static int dateDiffElapsedInMinutes(DateTime dateTime) {
    final Duration duration = DateTime.now().difference(dateTime);
    return duration.inHours * 60 + duration.inMinutes;
  }

  static int dateDiffElapsedInSeconds(DateTime dateTime) {
    final Duration duration = DateTime.now().difference(dateTime);
    return duration.inSeconds;
  }

  static int dateToUnixSeconds(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch ~/ 1000;
  }

  static DateTime unixSecondsToDate(int unixSeconds) {
    return DateTime.fromMillisecondsSinceEpoch(unixSeconds * 1000, isUtc: false);
  }

  static String dateToText(DateTime dt, {bool flagOnlyDate = true, bool trimYear = false}) {
    // print(new DateFormat.yMMMd().format(new DateTime.now()));
    String formatStr = trimYear ? "dd.MM" : "dd.MM.yyyy";
    if (flagOnlyDate == false) {
      formatStr = "$formatStr HH:mm";
    }
    DateFormat f = DateFormat(formatStr);

    // DateTime dt = DateTime.fromMillisecondsSinceEpoch(n);
    return f.format(dt);
  }

  static String dateToShortText(DateTime dt, {bool flagOnlyDate = true, bool trimYear = false}) {
    // print(new DateFormat.yMMMd().format(new DateTime.now()));
    String formatStr = trimYear ? "MMM d" : "MMM d, yyyy";
    if (flagOnlyDate == false) {
      formatStr = "$formatStr HH:mm";
    }

    // String langTag = LangService_all.getStoredLocale().toString();
    DateFormat f = DateFormat(formatStr, "en");
    // DateFormat f = DateFormat.MMMd(langTag);
    // DateTime dt = DateTime.fromMillisecondsSinceEpoch(n);
    return f.format(dt);
  }

  static String dateToHoursText(DateTime date) {
    return DateFormat("HH:mm").format(date);
  }

  //TODO pass lang coutnry name
  static String getWeekDayName(int weekDay) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return DateFormat(DateFormat.WEEKDAY, "en").format(firstDayOfWeek.add(Duration(days: weekDay)));
    // return DateFormat(DateFormat.WEEKDAY, LangService_all.getStoredLocale().countryCode.toLowerCase()).format();
    // return DateFormat("HH:mm").format(date);
  }
}
