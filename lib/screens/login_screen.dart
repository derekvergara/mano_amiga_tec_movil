import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../services/usuario_service.dart';
import '../models/usuario.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UsuarioService _usuarioService = UsuarioService();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      List<Usuario> usuarios = await _usuarioService.obtenerUsuarios();

      // Verifica si las credenciales existen en la lista de usuarios
      final usuarioValido = usuarios.any((usuario) =>
          usuario.username == username && usuario.password == password);

      if (usuarioValido) {
        // Guardar estado de sesión
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Redirigir a la página principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Credenciales incorrectas
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Credenciales incorrectas")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al conectarse al servidor")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Fondo transparente
        elevation: 0, // Sin sombra
        toolbarHeight: 0.0,
      ),
      body: Stack(
        children: [
          // Fondo blanco
          Container(
            color: Colors.white,
          ),

          // Círculo en la parte inferior menos color
          Positioned(
            bottom: -150,
            right: -85,
            child: Container(
              width: 575,
              height: 575,
              decoration: BoxDecoration(
                color: const Color.fromARGB(118, 64, 195, 255),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Círculo en la parte superior izquierda
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Icono para regresar en la parte superior izquierda
          Container(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: const Color.fromARGB(255, 255, 255, 255),
                size: 35,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Círculo en la parte inferior
          Positioned(
            bottom: -150,
            right: -50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: const Color(0xFF40C4FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Logo de la app
          Positioned(
            top: 50,
            left: 180,
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(
                  'assets/images/logo.png'), // Cambiar al logo que desees
            ),
          ),

          // Letras de iniciar sesion en la parte superior izquierda
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              "Iniciar \nSesión",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Contenido del formulario de login
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: "Usuario"),
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Cambia el color del texto
                        fontSize: 18, // Cambia el tamaño de la letra
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Contraseña"),
                      obscureText: true,
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Cambia el color del texto
                        fontSize: 18, // Cambia el tamaño de la letra
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Configuracion del boton
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 13), // Tamaño del botón
                        side: BorderSide(color: Colors.blueAccent, width: 1)),
                    child: Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 20, // Tamaño de la letra
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent, // Color de la letra
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
