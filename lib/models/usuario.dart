class Usuario {
  final int id;
  final String username;
  final String password;

  Usuario({required this.id, required this.username, required this.password});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }
}
