import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  final String baseUrl = "http://192.168.18.240:8080/api/usuario/listado";

  Future<List<Usuario>> obtenerUsuarios() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener la lista de usuarios");
    }
  }

  static const String _baseUrl = "http://192.168.18.240:8080/api/usuario";

  static Future<bool> register(String username, String password) async {
    final url = Uri.parse("$_baseUrl/IngresarUsuario");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );

    return response.statusCode ==
        201; // Devuelve true si la API responde con éxito
  }
}
