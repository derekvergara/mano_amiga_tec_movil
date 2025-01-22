import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  //final String baseUrl = "https://creative-joy-production.up.railway.app/api/usuario/listado";
  final String baseUrl =
      "http://192.168.18.240:8080/api/usuario"; // URL para conecta con el movil localmente

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

  // Método para iniciar sesión
  Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    try {
      print("Enviando solicitud POST a $url con:");
      print({"username": username, "password": password});

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print("Estado de respuesta: ${response.statusCode}");
      print("Cuerpo de respuesta: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("Respuesta exitosa: $responseData");
        return responseData['success'] ?? false;
      } else if (response.statusCode == 401) {
        print("Credenciales incorrectas");
        return false;
      } else {
        print("Error en el servidor: ${response.statusCode}");
        throw Exception("Error en el servidor: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al conectar con el servidor: $e");
      throw Exception("Error al conectar con el servidor: $e");
    }
  }

  //static const String _baseUrl ="https://creative-joy-production.up.railway.app/api/usuario";
  static const String _baseUrl = "http://192.168.18.240:8080/api/usuario";

  /*static Future<bool> register(String username, String password) async {
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
  }*/

  static Future<bool> registerUser({
    required String username,
    required String password,
    required String nombre,
    required int edad,
    required String telefono,
    required String correo,
    String? carnet,
    int? porcentajeDiscapacidad,
  }) async {
    final url = Uri.parse("$_baseUrl/IngresarUsuario");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": username,
        "password": password,
        "nombre": nombre,
        "edad": edad,
        "telefono": telefono,
        "correo": correo,
        "carnet": carnet,
        "porcentaje_discapacidad": porcentajeDiscapacidad,
      }),
    );

    return response.statusCode == 201; // Devuelve true si se registra con éxito
  }
}
