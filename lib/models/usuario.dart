class Usuario {
  final int id;
  final String
      usuario; // Cambiado de "username" a "usuario" para que coincida con el backend
  final String
      password; // Cambiado de "pasword" para corregir el typo del backend
  final String nombre;
  final int edad;
  final String telefono;
  final String correo;
  final bool carnetDiscapacidad; // Para indicar si tiene carnet de discapacidad
  final int?
      porcentajeDeDiscapacidad; // Puede ser nulo si no tiene discapacidad
  final String? numeroCarnet; // Puede ser nulo si no tiene carnet

  Usuario({
    required this.id,
    required this.usuario,
    required this.password,
    required this.nombre,
    required this.edad,
    required this.telefono,
    required this.correo,
    required this.carnetDiscapacidad,
    this.porcentajeDeDiscapacidad,
    this.numeroCarnet,
  });

  // Crear un objeto Usuario a partir de un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      usuario: json['usuario'],
      password: json['pasword'],
      nombre: json['nombre'],
      edad: json['edad'],
      telefono: json['telefono'],
      correo: json['correo'],
      carnetDiscapacidad: json['carnet_discapacidad'],
      porcentajeDeDiscapacidad: json['porcentaje_de_discapacidad'],
      numeroCarnet: json['numero_carnet'],
    );
  }

  // Convertir un objeto Usuario a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario,
      'pasword': password,
      'nombre': nombre,
      'edad': edad,
      'telefono': telefono,
      'correo': correo,
      'carnet_discapacidad': carnetDiscapacidad,
      'porcentaje_de_discapacidad': porcentajeDeDiscapacidad,
      'numero_carnet': numeroCarnet,
    };
  }
}
