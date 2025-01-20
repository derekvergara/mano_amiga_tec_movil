import 'package:flutter/material.dart';
import '../services/usuario_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      final success = await UsuarioService.register(username, password);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Usuario registrado con éxito"),
        ));
        Navigator.pop(context); // Volver a la pantalla anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error al registrar usuario"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Por favor, completa todos los campos"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Fondo transparente
        elevation: 0, // Sin sombra
        toolbarHeight: 0.0,
      ),
      body: Stack(
        /*padding: const EdgeInsets.all(16.0),
        child: Column(*/
        children: [
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
            top: 65,
            left: 8,
            child: Text(
              "Registrarse",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Formulario de registro
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Contraseña"),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13), // Tamaño del botón
                          side: BorderSide(color: Colors.blueAccent, width: 1)),
                      child: Text(
                        "Registrar",
                        style: TextStyle(
                          fontSize: 20, // Tamaño de la letra
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Color de la letra
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //),
    );
  }
}
