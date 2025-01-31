class CargarTraduccion {
  final int? idCargarTraduccion; // Puede ser nulo
  final int? usuarioId; // Puede ser nulo si no se incluye en el JSON devuelto
  final String texto;
  final String tipoTraduccion;
  final String fechaTraduccion;

  CargarTraduccion({
    this.idCargarTraduccion,
    this.usuarioId,
    required this.texto,
    required this.tipoTraduccion,
    required this.fechaTraduccion,
  });

  // Método para convertir un JSON a un objeto CargarTraduccion
  factory CargarTraduccion.fromJson(Map<String, dynamic> json) {
    return CargarTraduccion(
      idCargarTraduccion: json['id_historial_traduccion'] as int?,
      usuarioId:
          json['usuario_id'] as int?, // Debe coincidir con el JSON del backend
      texto: json['texto'] as String,
      tipoTraduccion: json['tipo_traduccion'] as String,
      fechaTraduccion: json['fecha_traduccion'] as String,
    );
  }

  // Método para convertir un objeto CargarTraduccion a un JSON
  Map<String, dynamic> toJson() {
    return {
      if (idCargarTraduccion != null)
        'id_historial_traduccion': idCargarTraduccion,
      'usuario_id':
          usuarioId, // Esto debe coincidir con lo que espera el backend
      'texto': texto,
      'tipo_traduccion': tipoTraduccion,
      'fecha_traduccion': fechaTraduccion,
    };
  }
}
