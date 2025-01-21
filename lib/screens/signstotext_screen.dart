import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  _SignToTextScreenState createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen>
    with WidgetsBindingObserver {
  late CameraController _cameraController;
  bool isCameraInitialized = false;
  String translatedText = "";
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
    _initTts();
  }

  void initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0], // Usa la cámara trasera
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    }
  }

  void _initTts() {
    flutterTts.setLanguage("es-ES");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
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

  void speakText() {
    if (translatedText.isNotEmpty) {
      flutterTts.speak(translatedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Traductor IA', // Cambia el texto aquí
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Vista de la cámara ajustada para orientación vertical con borde
          Expanded(
            flex: 3,
            child: isCameraInitialized
                ? Padding(
                    padding: const EdgeInsets.all(
                        3.0), // Borde alrededor de la cámara
                    child: ClipRect(
                      child: Transform.rotate(
                        angle:
                            90 * (3.1415926535897932 / 180), // Rotar 90 grados
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              width:
                                  300, // Cambia este valor para ajustar el ancho
                              height:
                                  250, // Cambia este valor para ajustar el alto
                              child: CameraPreview(_cameraController),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 75,
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
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
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
                SizedBox(
                  width: double
                      .infinity, // Hacer que el botón ocupe todo el ancho disponible
                  child: FloatingActionButton.extended(
                    onPressed: speakText,
                    label: Text('Reproducir'),
                    icon: Icon(Icons
                        .play_arrow), // Cambiar el ícono a un reproductor de audio
                  ),
                ),
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
                    backgroundColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  child: Text('Limpiar'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
