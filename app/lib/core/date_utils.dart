/// Parses dates like "Κυρ 09/02/2025" or "09/02/2025" into DateTime.
DateTime? parseGreekDate(String dateStr) {
  // Strip day prefix like "Κυρ " or "Sun "
  final cleaned = dateStr.replaceFirst(RegExp(r'^[A-Za-zΑ-Ωα-ωά-ώ]{2,4}\s+'), '');
  final parts = cleaned.split('/');
  if (parts.length != 3) return null;
  try {
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  } catch (_) {
    return null;
  }
}

/// Parses time range like "10:00 11:00" → (startHour, startMinute, endHour, endMinute).
({int startHour, int startMinute, int endHour, int endMinute})? parseTimeRange(String timeStr) {
  final parts = timeStr.trim().split(RegExp(r'\s+'));
  if (parts.length != 2) return null;
  final start = parts[0].split(':');
  final end = parts[1].split(':');
  if (start.length != 2 || end.length != 2) return null;
  try {
    return (
      startHour: int.parse(start[0]),
      startMinute: int.parse(start[1]),
      endHour: int.parse(end[0]),
      endMinute: int.parse(end[1]),
    );
  } catch (_) {
    return null;
  }
}

/// Combines a Greek date and time range into a DateTime for the start time.
DateTime? parseBookingDateTime(String dateStr, String timeStr) {
  final date = parseGreekDate(dateStr);
  if (date == null) return null;
  final time = parseTimeRange(timeStr);
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.startHour, time.startMinute);
}

/// Returns a human-readable countdown string.
String formatCountdown(DateTime classTime, {required bool isGreek}) {
  final now = DateTime.now();
  final diff = classTime.difference(now);
  if (diff.isNegative) return isGreek ? 'Παρελθόν' : 'Past';
  if (diff.inMinutes < 60) return isGreek ? 'σε ${diff.inMinutes} λεπτά' : 'in ${diff.inMinutes} min';
  if (diff.inHours < 24) return isGreek ? 'σε ${diff.inHours} ώρες' : 'in ${diff.inHours} hours';
  if (diff.inDays == 0) return isGreek ? 'Σήμερα' : 'Today';
  if (diff.inDays == 1) return isGreek ? 'Αύριο' : 'Tomorrow';
  return isGreek ? 'σε ${diff.inDays} ημέρες' : 'in ${diff.inDays} days';
}
