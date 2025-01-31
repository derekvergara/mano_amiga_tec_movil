class HistorialTraduccion {
  final int? idHistorialTraduccion;
  final int usuarioId;
  final String texto;
  final String tipoTraduccion;
  final String fechaTraduccion;

  HistorialTraduccion({
    this.idHistorialTraduccion,
    required this.usuarioId,
    required this.texto,
    required this.tipoTraduccion,
    required this.fechaTraduccion,
  });

  // Método para convertir un JSON a un objeto HistorialTraduccion
  factory HistorialTraduccion.fromJson(Map<String, dynamic> json) {
    return HistorialTraduccion(
      idHistorialTraduccion: json['id_historial_traduccion'],
      usuarioId: json['usuario_id'],
      texto: json['texto'],
      tipoTraduccion: json['tipo_traduccion'],
      fechaTraduccion: json['fecha_traduccion'],
    );
  }

  // Método para convertir un objeto HistorialTraduccion a un JSON
  Map<String, dynamic> toJson() {
    return {
      'usuario': {'id': usuarioId},
      'texto': texto,
      'tipo_traduccion': tipoTraduccion,
      'fecha_traduccion': fechaTraduccion,
    };
  }
}
