import 'package:flutter/material.dart';
import 'settings_screen.dart';

class AlphabetScreen extends StatelessWidget {
  final String title;

  const AlphabetScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Abecedario",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Inicia boton letras
                ElevatedButton(
                  onPressed: () {
                    print("Boton ' Abecedario' presionado");
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.abc,
                            size: 40,
                          ),
                          SizedBox(width: 20),
                          Text('Abecedario'),
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
                //Inicia boton numeros
                ElevatedButton(
                  onPressed: () {
                    print("Boton ' Abecedario' presionado");
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.numbers,
                            size: 40,
                          ),
                          SizedBox(width: 20),
                          Text('Numeros'),
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
                //Inicia boton Meses
                ElevatedButton(
                  onPressed: () {
                    print("Boton ' Meses' presionado");
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_month,
                            size: 40,
                          ),
                          SizedBox(width: 20),
                          Text('Meses del Año'),
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
              ],
            ),
          )),
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
                              title: "Abecedario",
                            ),
                          ),
                        );
                        print("Abecedario presionado");
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
