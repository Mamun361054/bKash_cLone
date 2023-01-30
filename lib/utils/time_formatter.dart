import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Formats a given UNIX millisecond timestamp into a human-readable string.
///
/// Progresses from smallest unit (second), to largest (years)
String formatTime(int timestamp) {
  /// The number of milliseconds that have passed since the timestamp
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference);
  } else if (difference < 3600000) {
    result = countMinutes(difference);
  } else if (difference < 86400000) {
    result = countHours(difference);
  } else if (difference < 604800000) {
    result = countDays(difference);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference);
  } else {
    result = countYears(difference);
  }

  return !result.startsWith("J") ? '$result ago' : result;
}

/// Converts the time difference to a number of seconds.
/// This function truncates to the lowest second.
///   returns ("Just now" OR "X seconds")
String countSeconds(int difference) {
  int count = (difference / 1000).truncate();
  return count > 1 ? '$count seconds' : 'Just now';
}

/// Converts the time difference to a number of minutes.
/// This function truncates to the lowest minute.
///   returns ("1 minute" OR "X minutes")
String countMinutes(int difference) {
  int count = (difference / 60000).truncate();
  return count.toString() + (count > 1 ? ' minutes' : ' minute');
}

/// Converts the time difference to a number of hours.
/// This function truncates to the lowest hour.
///   returns ("1 hour" OR "X hours")
String countHours(int difference) {
  int count = (difference / 3600000).truncate();
  return count.toString() + (count > 1 ? ' hours' : ' hour');
}

/// Converts the time difference to a number of days.
/// This function truncates to the lowest day.
///   returns ("1 day" OR "X days")
String countDays(int difference) {
  int count = (difference / 86400000).truncate();
  return count.toString() + (count > 1 ? ' days' : ' day');
}

/// Converts the time difference to a number of weeks.
/// This function truncates to the lowest week.
///   returns ("1 week" OR "X weeks" OR "1 month")
String countWeeks(int difference) {
  int count = (difference / 604800000).truncate();
  if (count > 3) {
    return '1 month';
  }
  return count.toString() + (count > 1 ? ' weeks' : ' week');
}

/// Converts the time difference to a number of months.
/// This function rounds to the nearest month.
///   returns ("1 month" OR "X months" OR "1 year")
String countMonths(int difference) {
  int count = (difference / 2628003000).round();
  count = count > 0 ? count : 1;
  if (count > 12) {
    return '1 year';
  }
  return count.toString() + (count > 1 ? ' months' : ' month');
}

/// Converts the time difference to a number of years.
/// This function truncates to the lowest year.
///   returns ("1 year" OR "X years")
String countYears(int difference) {
  int count = (difference / 31536000000).truncate();
  return count.toString() + (count > 1 ? ' years' : ' year');
}

String timeUntil(DateTime date) {
  return timeago.format(date, allowFromNow: true, locale: 'en');
}

DateTime getDateTimeFromTimestamp(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp);
}

String getTimeFromTimestamp(int timestamp) {
  var format = DateFormat('HH:mm');
  var date = getDateTimeFromTimestamp(
    timestamp,
  );
  return format.format(date);
}

///return duration from current date time(by difference)
///we get how many days hours minutes seconds spanned from now
Duration getDuration(int timestamp) {
  var now = DateTime.now();
  print('now ${now.toString()}');
  var date = getDateTimeFromTimestamp(timestamp);
  print('date ${date.toString()}');
  return now.difference(date);
}

//read timeStamp and return string
String readTimestamp(int timestamp) {
  var now = DateTime.now().add(const Duration(hours: 5, minutes: 30)).toUtc();
  var date = getDateTimeFromTimestamp(timestamp);
  debugPrint(date.toString());
  var diff = now.difference(date);
  var time = '';

  if (diff.inMinutes <= 0 && diff.inHours <= 0) {
    time = getTimeFromNow(diff);
  } else {
    time = getTimeAgoFromNow(diff);
  }
  return time;
}

String getTimeFromNow(Duration diff) {
  String time = '';
  if (diff.inHours > 0 && diff.inHours < 24) {
    if (diff.inHours == 1) {
      time = '${diff.inHours} hour from now';
    } else {
      time = '${diff.inHours} hours from now';
    }
  } else if (diff.inMinutes > 0 && diff.inMinutes < 60) {
    if (diff.inMinutes == 1) {
      time = '${diff.inMinutes} minute from now';
    } else {
      time = '${diff.inMinutes} minutes from now';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day from now';
    } else {
      time = '${diff.inDays} days from now';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} week from now';
    } else {
      time = '${(diff.inDays / 7).floor()} weeks from now';
    }
  }
  return time;
}

String getTimeAgoFromNow(Duration diff) {
  String time = '';
  if (diff.inHours > 0 && diff.inHours < 24) {
    if (diff.inHours == 1) {
      time = '${diff.inHours} hour ago';
    } else {
      time = '${diff.inHours} hours ago';
    }
  } else if (diff.inMinutes > 0 && diff.inMinutes < 60) {
    if (diff.inMinutes == 1) {
      time = '${diff.inMinutes} minute ago';
    } else {
      time = '${diff.inMinutes} minutes ago';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day ago';
    } else {
      time = '${diff.inDays} days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} week ago';
    } else {
      time = '${(diff.inDays / 7).floor()} weeks ago';
    }
  }
  return time;
}
