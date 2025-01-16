import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_screen.dart';
import 'settings_screen.dart';
import 'alphabet_screen.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _start(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Elimina el estado de sesión

    // Regresa al login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina el botón de "Back"
        backgroundColor: Colors.blueAccent,
        title: Text(
          "MANO AMIGA TEC",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _start(context),
            color: Colors.white,
          )
        ],
      ),
      body: Stack(
        children: [
          // Fondo
          Container(
            color: Colors.white,
          ),

          // Contenido principal centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Función para el botón "Señas a texto"
                      print("Botón 'Señas a texto' presionado");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Text('Señas a texto'),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Función para el botón "Texto a señas"
                      print("Botón 'Texto a señas' presionado");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.edit_note,
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Text('Texto a señas'),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Función para el botón "Historial"
                      print("Botón 'Historial' presionado");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.history,
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Text('Historial'),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 30,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Función para el botón "Juegos"
                      // ...
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.games,
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Text('Juegos'),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Logo de la app
                  Positioned(
                    child: CircleAvatar(
                      radius: 140,
                      backgroundImage: AssetImage(
                          'assets/images/logo.png'), // Cambiar al logo que desees
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer fijo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Espacios entre los botones
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left:
                            25), // Mueve el icono de libro un poco hacia el centro
                    child: IconButton(
                      icon: Icon(
                        Icons.book,
                        size: 40,
                      ),
                      onPressed: () {
                        // Acción para el botón del libro
                        // Navega a la vista AlphabetScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlphabetScreen(
                              title: "Libro",
                            ),
                          ),
                        );
                        print("Libro presionado");
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.lightBlue,
                      size: 40,
                    ),
                    onPressed: () {
                      // Acción para el botón de la casa
                      print("Casa presionada");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right:
                            25.0), // Mueve el icono de ajustes un poco hacia el centro
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 40,
                      ),
                      onPressed: () {
                        // Acción para el botón de ajustes
                        print("Ajustes presionados");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
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
