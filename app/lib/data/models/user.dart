class User {
  final String name;
  final String expiry;
  final String balance;

  const User({required this.name, required this.expiry, required this.balance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
      balance: json['balance'] as String? ?? '',
    );
  }
}
