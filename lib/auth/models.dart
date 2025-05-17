class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isStaff,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'] as bool,
      isStaff: json['is_staff'] as bool,
    );
  }
}
