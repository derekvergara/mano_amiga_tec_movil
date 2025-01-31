// Modelo Juego
class Juego {
  int? idJuego;
  String nombreJuego;
  String descripcionJuego;
  int niveles;

  Juego({
    this.idJuego,
    required this.nombreJuego,
    required this.descripcionJuego,
    required this.niveles,
  });

  // Método para convertir de JSON a objeto Juego
  factory Juego.fromJson(Map<String, dynamic> json) {
    return Juego(
      idJuego: json['idJuego'],
      nombreJuego: json['nombre_juego'],
      descripcionJuego: json['descripcion_juego'],
      niveles: json['niveles'],
    );
  }

  // Método para convertir de objeto Juego a JSON
  Map<String, dynamic> toJson() {
    return {
      'idJuego': idJuego,
      'nombre_juego': nombreJuego,
      'descripcion_juego': descripcionJuego,
      'niveles': niveles,
    };
  }
}
