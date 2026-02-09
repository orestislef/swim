class TimeSlot {
  final String id;
  final String course;
  final String date;
  final String time;
  final String teacher;
  final int persons;
  final bool canBook;
  final String status;

  const TimeSlot({
    required this.id,
    required this.course,
    required this.date,
    required this.time,
    required this.teacher,
    required this.persons,
    required this.canBook,
    required this.status,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id']?.toString() ?? '',
      course: json['course'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      persons: (json['persons'] as num?)?.toInt() ?? 0,
      canBook: json['canBook'] as bool? ?? false,
      status: json['status'] as String? ?? '',
    );
  }

  bool get isCancelled => status == 'cancelled' || persons < 0;
  bool get isFull => !canBook && !isCancelled;
}
