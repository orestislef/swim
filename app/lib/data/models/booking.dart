class Booking {
  final String id;
  final String date;
  final String time;
  final String course;
  final String status;
  final String statusText;

  const Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.course,
    required this.status,
    required this.statusText,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      course: json['course'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusText: json['statusText'] as String? ?? '',
    );
  }

  bool get canCancel => status == 'pending';
}
