import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:shared_preferences/shared_preferences.dart';
import '../models/historial_traduccion.dart';
import '../services/historial_traduccion_service.dart';

class TextToSignScreen extends StatefulWidget {
  @override
  _TextToSignScreenState createState() => _TextToSignScreenState();
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _currentImage; // Imagen actual que se mostrará
  int _currentIndex = 0; // Índice actual para iterar las letras
  List<String> _letters = []; // Lista de letras del texto ingresado
  Timer? _timer; // Temporizador para cambiar imágenes automáticamente

  @override
  void dispose() {
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTranslation() {
    // Obtén el texto ingresado y aplica validaciones
    String text = _textController.text.toLowerCase();

    // Reemplazar letras con tildes por letras normales
    text = text
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');

    // Eliminar todo lo que no sea alfanumérico (letras y números)
    text = text.replaceAll(RegExp(r'[^a-z0-9]'), '');

    // Verificar si el texto está vacío después de la limpieza
    if (text.isEmpty) {
      setState(() {
        _currentImage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("El texto no contiene caracteres válidos")),
      );
      return;
    }

    // Convertir el texto a una lista de letras
    setState(() {
      _letters = text.split('');
      _currentIndex = 0;
      _currentImage = 'assets/sign/${_letters[_currentIndex]}.png';
    });

    // Configurar el temporizador para cambiar las imágenes
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex < _letters.length) {
          _currentImage = 'assets/sign/${_letters[_currentIndex]}.png';
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _clearTranslation() {
    _textController.clear();
    setState(() {
      _letters = [];
      _currentImage = null;
      _currentIndex = 0;
    });
    _timer?.cancel();
  }

  Future<void> _saveTranslation() async {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, ingrese un texto para traducir")),
      );
      return;
    }

    try {
      // Obtener el id del usuario autenticado
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(
          'userId'); // Supongo que guardaste el ID del usuario como 'userId'

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error: No se encontró la sesión del usuario")),
        );
        return;
      }

      // Obtener la fecha actual
      final fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Crear un objeto de tipo HistorialTraduccion
      final nuevoHistorial = HistorialTraduccion(
        // El ID será generado por el backend
        usuarioId: userId,
        texto: text,
        tipoTraduccion: "Texto a señas",
        fechaTraduccion: fechaActual,
      );

      // Guardar en el backend
      final success =
          await HistorialTraduccionService().crearHistorial(nuevoHistorial);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Traducción guardada con éxito")),
        );
        _clearTranslation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la traducción")),
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
        backgroundColor: Colors.blue,
        title: const Text(
          "Traductor IA",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: _currentImage == null
                  ? const Icon(Icons.image, size: 50, color: Colors.grey)
                  : Image.asset(
                      _currentImage!,
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Traducción",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Texto a traducir a señas",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Texto traducido",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Antes de traducir verifique es este escrito correctamente",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startTranslation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              ),
              child: const Text(
                "Traducir",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveTranslation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    "Guardar",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearTranslation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    "Limpiar",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'dart:async';
import 'package:flutter/material.dart';

class TextToSignScreen extends StatefulWidget {
  @override
  _TextToSignScreenState createState() => _TextToSignScreenState();
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _currentImage; // Imagen actual que se mostrará
  int _currentIndex = 0; // Índice actual para iterar las letras
  List<String> _letters = []; // Lista de letras del texto ingresado
  Timer? _timer; // Temporizador para cambiar imágenes automáticamente

  @override
  void dispose() {
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTranslation() {
    String text = _textController.text.toLowerCase().replaceAll(' ', '');
    if (text.isEmpty) {
      setState(() {
        _currentImage = null;
      });
      return;
    }

    setState(() {
      _letters = text.split('');
      _currentIndex = 0;
      _currentImage = 'assets/sign/${_letters[_currentIndex]}.png';
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex < _letters.length) {
          _currentImage = 'assets/sign/${_letters[_currentIndex]}.png';
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _clearTranslation() {
    _textController.clear();
    setState(() {
      _letters = [];
      _currentImage = null;
      _currentIndex = 0;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Traductor IA",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: _currentImage == null
                  ? const Icon(Icons.image, size: 50, color: Colors.grey)
                  : Image.asset(
                      _currentImage!,
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Traducción",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Texto a traducir a señas",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Texto traducido",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Antes de traducir verifique es este escrito correctamente",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startTranslation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              ),
              child: const Text(
                "Traducir",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Guardar presionado");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    "Guardar",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearTranslation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    "Limpiar",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/
