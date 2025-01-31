import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_screen.dart';
import 'home_screen.dart'; // Asegúrate de importar tus pantallas
import 'alphabet_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false; // Controla el tema Claro/Oscuro
  String _userName = "Usuario"; // Nombre del usuario por defecto
  String _userEmail = "invitado@ejemplo.com"; // Correo por defecto
  String _userNombre = "Invitado";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "Usuario";
      _userEmail = prefs.getString('userEmail') ?? "invitado@ejemplo.com";
      _userNombre = prefs.getString('userNombre') ?? "Invitado";
    });
  }

  Future<void> _start(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Elimina el estado de sesión
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userNombre');

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
        title: Text(
          "AJUSTES",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        automaticallyImplyLeading: false, // Elimina el botón de "Back"
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              // Acción para el botón de ajustes en el AppBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Muy pronto se habilitara esta opcion")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Tarjeta para la información del usuario
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(_userNombre), // Nombre del usuario
                            subtitle: Text(_userEmail), // Correo del usuario
                          ),
                          ElevatedButton(
                            onPressed: () => _start(context),
                            style: ElevatedButton.styleFrom(
                                //backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red, width: 1)),
                            child: Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tarjeta para otros ajustes
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.support),
                            title: Text('Soporte'),
                          ),
                          ListTile(
                            leading: Icon(Icons.share),
                            title: Text('Redes Sociales'),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/icons/temas.png', // Ruta del ícono en tus assets
                              width: 25, // Tamaño del ícono
                              height: 25,
                            ),
                            title: SwitchListTile(
                              title: Text('Tema: Claro/Oscuro'),
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() {
                                  _isDarkMode = value; // Cambia el tema
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer fijo para navegación
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
                        // Navega a la pantalla de "Libro" (reemplaza con la pantalla adecuada)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AlphabetScreen(title: "Libro"),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: 40,
                    ),
                    onPressed: () {
                      // Navega a la pantalla de inicio
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right:
                            25.0), // Mueve el icono de ajustes un poco hacia el centro
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.lightBlue,
                        size: 40,
                      ),
                      onPressed: () {
                        // Ya estamos en la pantalla de ajustes, no hacemos nada
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Ya estás en la pantalla de Ajustes")),
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
