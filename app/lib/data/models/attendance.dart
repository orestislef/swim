class Attendance {
  final String date;
  final String time;

  const Attendance({required this.date, required this.time});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );
  }
}
