class User {
  final String username;
  final String email;
  final String password;
  final String role;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}
