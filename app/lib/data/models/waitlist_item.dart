class WaitlistItem {
  final String details;

  const WaitlistItem({required this.details});

  factory WaitlistItem.fromJson(Map<String, dynamic> json) {
    return WaitlistItem(details: json['details'] as String? ?? '-');
  }
}
