class Subscription {
  final String name;
  final String start;
  final String end;
  final String attendances;
  final String remaining;

  const Subscription({
    required this.name,
    required this.start,
    required this.end,
    required this.attendances,
    required this.remaining,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      name: json['name'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      attendances: json['attendances'] as String? ?? '',
      remaining: json['remaining'] as String? ?? '',
    );
  }
}
