import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  //final String baseUrl = "https://creative-joy-production.up.railway.app/api/usuario/listado";
  //final String baseUrl = "http://192.168.18.240:8080/api/usuario"; // URL para conectar con el móvil localmente
  final String baseUrl =
      "http://192.168.52.23:8080/api"; // URL para conectar con el móvil localmente

  // Método para obtener la lista de usuarios
  Future<List<Usuario>> obtenerUsuarios() async {
    final url = Uri.parse("$baseUrl/listado");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener la lista de usuarios");
    }
  }

  Future<Usuario?> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': username, 'pasword': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Devuelve un objeto Usuario con los datos del backend
        return Usuario(
          id: data['id'],
          usuario: username,
          password: password,
          nombre: data['nombre'] ?? "",
          edad: 0, // No devuelto por el backend, se puede ajustar
          telefono: data['telefono'] ?? "",
          correo: data['correo'] ?? "",
          carnetDiscapacidad: false, // Ajustar según el backend si es necesario
          porcentajeDeDiscapacidad:
              0, // Ajustar según el backend si es necesario
          numeroCarnet: "", // Ajustar según el backend si es necesario
        );
      }
    } else if (response.statusCode == 401) {
      return null; // Credenciales incorrectas
    } else {
      throw Exception("Error en el servidor: ${response.statusCode}");
    }
  }

  // Método para registrar un usuario
  //static const String _baseUrl ="https://creative-joy-production.up.railway.app/api/usuario";
  static const String _baseUrl = "http://192.168.52.23:8080/api";

  static Future<bool> registerUser({
    required String usuario,
    required String password,
    required String nombre,
    required int edad,
    required String telefono,
    required String correo,
    required bool carnetDiscapacidad,
    int? porcentajeDiscapacidad,
    String? numeroCarnet,
  }) async {
    final url = Uri.parse("$_baseUrl/usuario");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "usuario": usuario,
        "pasword": password,
        "nombre": nombre,
        "edad": edad,
        "telefono": telefono,
        "correo": correo,
        "carnet_discapacidad": carnetDiscapacidad,
        "porcentaje_de_discapacidad": porcentajeDiscapacidad,
        "numero_carnet": numeroCarnet,
      }),
    );

    print("Estado de respuesta: ${response.statusCode}");
    print("Cuerpo de respuesta: ${response.body}");

    return response.statusCode == 201; // Devuelve true si se registra con éxito
  }
}
