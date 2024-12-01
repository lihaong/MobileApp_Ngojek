import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

ThemeMode getTimeZoneThemeMode(String timezone) {
  final String currentTime = _getCurrentTimeInTimeZone(timezone);
  String compare = currentTime.substring(0, 2);
  int temp = int.parse(compare);

  if (temp > 6 && temp < 18) {
    return ThemeMode.light;
  } else {
    return ThemeMode.dark;
  }
}

String _getCurrentTimeInTimeZone(String timezone) {
  tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(timezone));
  return DateFormat('HH:mm:ss').format(now);
}
