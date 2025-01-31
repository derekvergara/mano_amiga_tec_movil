// Servicio para gestionar los juegos desde el backend
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/juego.dart';

class JuegoService {
  final String baseUrl =
      'http://192.168.52.23:8080/api/juego'; // URL del backend

  // Método para obtener la lista de juegos desde el backend
  Future<List<Juego>> getJuegos() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("🔵 Respuesta del servidor: ${response.body}"); // Ver qué JSON llega
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Juego.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener los juegos desde el backend');
    }
  }

  // Método para obtener un juego específico por ID desde el backend
  Future<Juego> getJuegoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Juego.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el juego');
    }
  }

  // Método para crear un nuevo juego en el backend
  Future<void> createJuego(Juego juego) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(juego.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el juego en el backend');
    }
  }

  // Método para actualizar un juego existente en el backend
  Future<void> updateJuego(Juego juego) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${juego.idJuego}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(juego.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el juego en el backend');
    }
  }

  // Método para eliminar un juego por ID en el backend
  Future<void> deleteJuego(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el juego en el backend');
    }
  }
}
