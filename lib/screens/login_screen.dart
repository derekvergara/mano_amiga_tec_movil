import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../services/usuario_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UsuarioService _usuarioService = UsuarioService();
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar el controlador para la animación del fondo
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // Configurar el gradiente animado
    _colorAnimation = ColorTween(
      begin: Colors.blue.shade100,
      end: Colors.purple.shade100,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos")),
      );
      return;
    }

    try {
      final usuario = await _usuarioService.login(username, password);

      if (usuario != null) {
        // Guardar estado de sesión y el id del usuario
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', usuario.id); // Guarda el id del usuario
        await prefs.setString(
            'userName', usuario.usuario); // Opcional: Guarda el usuario
        await prefs.setString(
            'userPassword', usuario.password); // Opcional: Guarda el Password
        await prefs.setString(
            'userNombre', usuario.nombre); // Opcional: Guarda el Nombre
        await prefs.setInt(
            'userEdad', usuario.edad); // Opcional: Guarda la edad
        await prefs.setString(
            'userTelefono', usuario.telefono); // Opcional: Guarda el Telefono
        await prefs.setString(
            'userEmail', usuario.correo); // Opcional: Guarda el correo
        await prefs.setBool('userCarnet',
            usuario.carnetDiscapacidad); // Opcional: Guarda el Carnet
        /*await prefs.setString(
            'userNumeroCarnet', usuario.numeroCarnet); // Opcional: Guarda el Numero de carnet
        await prefs.setInt(
            'userPorcentaje', usuario.porcentajeDeDiscapacidad); // Opcional: Guarda el Porcentaje
        */

        // Agregar un log para verificar si se está guardando el ID
        print("ID del usuario guardado en SharedPreferences: ${usuario.id}");
        print(
            "Nombre del usuario guardado en SharedPreferences: ${usuario.usuario}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario o contraseña incorrectos")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con el servidor: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        toolbarHeight: 0.0,
      ),
      body: Stack(
        children: [
          // Fondo animado (dentro del contenedor original)
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorAnimation.value ?? Colors.blue.shade100,
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
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
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),

          // Letras de iniciar sesión en la parte superior izquierda
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
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
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
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      side: BorderSide(color: Colors.blueAccent, width: 1),
                    ),
                    child: Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
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


/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../services/usuario_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UsuarioService _usuarioService = UsuarioService();

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos")),
      );
      return;
    }

    try {
      final success = await _usuarioService.login(username, password);

      if (success) {
        // Guardar estado de sesión
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Redirigir a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Credenciales incorrectas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario o contraseña incorrectos")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con el servidor: $e")),
      );
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
                  // Configuración del botón
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
*/