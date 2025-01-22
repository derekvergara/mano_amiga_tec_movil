import 'package:flutter/material.dart';
import '../services/usuario_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores de los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _carnetController = TextEditingController();
  final TextEditingController _porcentajeController = TextEditingController();

  // Estado del dropdown para discapacidad
  String _discapacidad = "No";
  bool _mostrarCamposDiscapacidad = false;

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final nombre = _nombreController.text.trim();
    final edad = int.tryParse(_edadController.text.trim()) ?? 0;
    final telefono = _telefonoController.text.trim();
    final correo = _correoController.text.trim();
    final carnet = _carnetController.text.trim();
    final porcentajeDiscapacidad =
        int.tryParse(_porcentajeController.text.trim()) ?? 0;

    if (username.isNotEmpty &&
        password.isNotEmpty &&
        nombre.isNotEmpty &&
        edad > 0 &&
        telefono.isNotEmpty &&
        correo.isNotEmpty &&
        (!_mostrarCamposDiscapacidad ||
            (carnet.isNotEmpty && porcentajeDiscapacidad > 0))) {
      final success = await UsuarioService.registerUser(
        username: username,
        password: password,
        nombre: nombre,
        edad: edad,
        telefono: telefono,
        correo: correo,
        carnet: _mostrarCamposDiscapacidad ? carnet : null,
        porcentajeDiscapacidad:
            _mostrarCamposDiscapacidad ? porcentajeDiscapacidad : null,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Usuario registrado con éxito"),
        ));
        Navigator.pop(context); // Volver a la pantalla anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al registrar usuario"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor, completa todos los campos"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrarse",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(234, 245, 93, 23),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 243, 110, 33),
                  Colors.purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Usuario",
                      labelStyle: TextStyle(
                          color: Colors.black), // Color del texto del label
                      filled: true, // Activa el color de fondo
                      fillColor: Color.fromARGB(
                          146, 255, 255, 255), // Color de fondo blanco
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde visible
                      ), // Ajuste del padding interno
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto del usuario
                      fontSize: 16, // Tamaño del texto
                    ),
                  ),

                  const SizedBox(height: 5),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: TextStyle(
                          color: Colors.black), // Color del texto del label
                      filled: true, // Activa el color de fondo
                      fillColor: Color.fromARGB(
                          146, 255, 255, 255), // Color de fondo blanco
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde visible
                      ), // Ajuste del padding interno
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto del usuario
                      fontSize: 16, // Tamaño del texto
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 5),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      labelStyle: TextStyle(
                          color: Colors.black), // Color del texto del label
                      filled: true, // Activa el color de fondo
                      fillColor: Color.fromARGB(
                          146, 255, 255, 255), // Color de fondo blanco
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde visible
                      ), // Ajuste del padding interno
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto del usuario
                      fontSize: 16, // Tamaño del texto
                    ),
                  ),

                  const SizedBox(height: 5),
                  TextField(
                    controller: _edadController,
                    decoration: const InputDecoration(
                      labelText: "Edad",
                      labelStyle: TextStyle(
                          color: Colors.black), // Color del texto del label
                      filled: true, // Activa el color de fondo
                      fillColor: Color.fromARGB(
                          146, 255, 255, 255), // Color de fondo blanco
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde visible
                      ), // Ajuste del padding interno
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto del usuario
                      fontSize: 16, // Tamaño del texto
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 5),
                  TextField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
                      labelStyle: TextStyle(
                          color: Colors.black), // Color del texto del label
                      filled: true, // Activa el color de fondo
                      fillColor: Color.fromARGB(
                          146, 255, 255, 255), // Color de fondo blanco
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde visible
                      ), // Ajuste del padding interno
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto del usuario
                      fontSize: 16, // Tamaño del texto
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 5),
                  TextField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: "Correo",
                      labelStyle: TextStyle(
                          color: Colors.black), // Color del texto del label
                      filled: true, // Activa el color de fondo
                      fillColor: Color.fromARGB(
                          146, 255, 255, 255), // Color de fondo blanco
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde visible
                      ), // Ajuste del padding interno
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto del usuario
                      fontSize: 16, // Tamaño del texto
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // Dropdown para discapacidad
                  Row(
                    children: [
                      const Text(
                        "¿Tiene discapacidad?",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      DropdownButton<String>(
                        value: _discapacidad,
                        items: const [
                          DropdownMenuItem(value: "No", child: Text("No")),
                          DropdownMenuItem(value: "Sí", child: Text("Sí")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _discapacidad = value!;
                            _mostrarCamposDiscapacidad = value == "Sí";
                          });
                        },
                      ),
                    ],
                  ),
                  if (_mostrarCamposDiscapacidad) ...[
                    TextField(
                      controller: _carnetController,
                      decoration: const InputDecoration(
                        labelText: "Carnet",

                        labelStyle: TextStyle(
                            color: Colors.black), // Color del texto del label
                        filled: true, // Activa el color de fondo
                        fillColor: Color.fromARGB(
                            146, 255, 255, 255), // Color de fondo blanco
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(12)), // Bordes redondeados
                          borderSide: BorderSide.none, // Sin borde visible
                        ), // Ajuste del padding interno
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Color del texto del usuario
                        fontSize: 16, // Tamaño del texto
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _porcentajeController,
                      decoration: const InputDecoration(
                        labelText: "Porcentaje de discapacidad",
                        labelStyle: TextStyle(
                            color: Colors.black), // Color del texto del label
                        filled: true, // Activa el color de fondo
                        fillColor: Color.fromARGB(
                            146, 255, 255, 255), // Color de fondo blanco
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(12)), // Bordes redondeados
                          borderSide: BorderSide.none, // Sin borde visible
                        ), // Ajuste del padding interno
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Color del texto del usuario
                        fontSize: 16, // Tamaño del texto
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      // Agregar una sombra púrpura
                      shadowColor: Colors.purple.withOpacity(0.5),
                      elevation: 10, // Intensidad de la sombra
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25), // Bordes redondeados
                      ),
                      backgroundColor: Colors
                          .transparent, // Fondo transparente para usar gradiente
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ), // Espaciado
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            12), // Coincidir bordes con el botón
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Registrar",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Texto blanco para contraste
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
