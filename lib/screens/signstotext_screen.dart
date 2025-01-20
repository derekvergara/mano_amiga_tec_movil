import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  _SignToTextScreenState createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  late CameraController _cameraController;
  String translatedText = "";

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void translateSignLanguage() {
    // Simula el texto traducido desde lenguaje de señas.
    setState(() {
      translatedText = "Texto traducido desde lenguaje de señas";
    });
  }

  void clearText() {
    setState(() {
      translatedText = "";
    });
  }

  void saveText() {
    // Implementa la lógica para guardar el texto traducido.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Texto guardado: $translatedText")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traductor IA'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Vista de la cámara o ícono de cámara si no está inicializada
          Expanded(
            flex: 3,
            child: _cameraController.value.isInitialized
                ? CameraPreview(_cameraController)
                : Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
          ),
          // Campo de texto para la traducción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Señas traducidas a texto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Texto traducido',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: translatedText),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          // Botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: saveText,
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: clearText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Limpiar'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: translateSignLanguage,
        child: Icon(Icons.mic),
      ),
    );
  }
}
