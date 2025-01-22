/*class Usuario {
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
}*/

class Usuario {
  final int id;
  final String username;
  final String password;
  final String nombre;
  final int edad;
  final String telefono;
  final String correo;
  final String? carnet; // Puede ser nulo si no tiene discapacidad
  final int? porcentajeDiscapacidad; // Puede ser nulo si no tiene discapacidad

  Usuario({
    required this.id,
    required this.username,
    required this.password,
    required this.nombre,
    required this.edad,
    required this.telefono,
    required this.correo,
    this.carnet,
    this.porcentajeDiscapacidad,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      nombre: json['nombre'],
      edad: json['edad'],
      telefono: json['telefono'],
      correo: json['correo'],
      carnet: json['carnet'], // Si el valor no está presente, será nulo
      porcentajeDiscapacidad:
          json['porcentaje_discapacidad'], // Si no está, será nulo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'nombre': nombre,
      'edad': edad,
      'telefono': telefono,
      'correo': correo,
      'carnet': carnet,
      'porcentaje_discapacidad': porcentajeDiscapacidad,
    };
  }
}
