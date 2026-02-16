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

/// Parses attendance strings like "5/20" into (used, total).
({int used, int total})? parseAttendances(String attendances) {
  final match = RegExp(r'(\d+)\s*/\s*(\d+)').firstMatch(attendances);
  if (match == null) return null;
  return (used: int.parse(match.group(1)!), total: int.parse(match.group(2)!));
}

/// Returns a human-readable countdown string.
String formatCountdown(DateTime classTime, {required String locale}) {
  final now = DateTime.now();
  final diff = classTime.difference(now);
  switch (locale) {
    case 'el':
      if (diff.isNegative) return 'Παρελθόν';
      if (diff.inMinutes < 60) return 'σε ${diff.inMinutes} λεπτά';
      if (diff.inHours < 24) return 'σε ${diff.inHours} ώρες';
      if (diff.inDays == 0) return 'Σήμερα';
      if (diff.inDays == 1) return 'Αύριο';
      return 'σε ${diff.inDays} ημέρες';
    case 'ru':
      if (diff.isNegative) return 'Прошло';
      if (diff.inMinutes < 60) return 'через ${diff.inMinutes} мин.';
      if (diff.inHours < 24) return 'через ${diff.inHours} ч.';
      if (diff.inDays == 0) return 'Сегодня';
      if (diff.inDays == 1) return 'Завтра';
      return 'через ${diff.inDays} дн.';
    default:
      if (diff.isNegative) return 'Past';
      if (diff.inMinutes < 60) return 'in ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'in ${diff.inHours} hours';
      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Tomorrow';
      return 'in ${diff.inDays} days';
  }
}
