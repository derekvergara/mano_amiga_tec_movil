import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart'; // Nueva pantalla para el registro
import 'home_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
              child: Image.asset(
                'assets/images/ista_rectangular.png',
                width: 290, // Ancho de la imagen
                height: 150, // Alto de la imagen
                fit: BoxFit.contain, // Ajusta cómo se adapta la imagen
              ),
            ),
            const SizedBox(height: 20),
            Positioned(
              top: 20, // Ajusta la distancia desde la parte superior
              right: 20, // Ajusta la distancia desde la derecha
              child: GestureDetector(
                child: const Text(
                  "&",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Requerido para usar `ShaderMask`
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Positioned(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(
                    'assets/images/logo_circular.png'), // Cambiar al logo que desees
              ),
            ),
            const SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 207, 233, 253),
                    Color.fromARGB(255, 236, 150, 252)
                  ], // Degradado del texto
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                "! Bienvenido ¡",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Requerido para usar `ShaderMask`
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("boton Login precionado");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    minimumSize:
                        const Size(100, 50), // Ancho y alto mínimos del botón
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20, // Espaciado horizontal dentro del botón
                      vertical: 0, // Espaciado vertical dentro del botón
                    ),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.purple
                        ], // Degradado del texto
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Requerido para usar `ShaderMask`
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("boton Sing up precionado");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    minimumSize:
                        const Size(100, 50), // Ancho y alto mínimos del botón
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20, // Espaciado horizontal dentro del botón
                      vertical: 0, // Espaciado vertical dentro del botón
                    ),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.purple
                        ], // Degradado del texto
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Requerido para usar `ShaderMask`
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                print("boton Invitado precionado");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.blue),
                minimumSize:
                    const Size(100, 50), // Ancho y alto mínimos del botón
                padding: const EdgeInsets.symmetric(
                  horizontal: 40, // Espaciado horizontal dentro del botón
                  vertical: 0, // Espaciado vertical dentro del botón
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Colors.blue, Colors.purple], // Degradado del texto
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Text(
                  "Ingresar como Invitado",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Requerido para usar `ShaderMask`
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
