class Progreso {
  final int? idProgreso;
  final int usuarioId;
  final int nivelActual;
  final double porcentajeProgreso;

  Progreso({
    this.idProgreso,
    required this.usuarioId,
    required this.nivelActual,
    required this.porcentajeProgreso,
  });

  // Convertir JSON a Objeto
  factory Progreso.fromJson(Map<String, dynamic> json) {
    print("🟡 JSON recibido en Progreso.fromJson(): $json"); // Debug
    return Progreso(
      idProgreso: json['id_progreso'],
      usuarioId: json['usuario'] != null ? json['usuario']['id'] : 0, // Verificación de null
      nivelActual: json['nivel_actual'],
      porcentajeProgreso: json['porcentaje_progreso'].toDouble(),
    );
  }

  // Convertir Objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      if (idProgreso != null) 'id_progreso': idProgreso,
      'usuario': {'id': usuarioId},
      'nivel_actual': nivelActual,
      'porcentaje_progreso': porcentajeProgreso,
    };
  }
}
