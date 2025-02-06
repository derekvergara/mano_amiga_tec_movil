import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:async'; // Importar para usar Timer

Timer? _captureTimer;

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
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
    _initTts();

    // Iniciar el timer para capturar imágenes cada 2 segundos
    _captureTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (isCameraInitialized) {
        captureAndSendImage();
      }
    });
  }

  // Método para capturar imagen, convertirla a base64 y enviar al servidor
  Future<void> captureAndSendImage() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      // Capturar la imagen
      final XFile imageFile = await _cameraController.takePicture();
      final bytes = await imageFile.readAsBytes();

      // Convertir la imagen a base64
      String base64Image = base64Encode(bytes);
      base64Image =
          'data:image/jpeg;base64,$base64Image'; // Asegúrate de que el formato coincide con el del backend

      // Enviar la imagen al backend
      final response = await http.post(
        Uri.parse(
            'http://192.168.3.11:5000/predict'), // Cambia esto por tu IP local si estás usando un dispositivo físico
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          translatedText +=
              data['prediction']; // Añadir la letra detectada al campo de texto
        });
      } else {
        print('Error en la predicción: ${response.body}');
      }
    } catch (e) {
      print('Error al capturar o enviar la imagen: $e');
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
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

  void switchCamera() async {
    if (cameras.isNotEmpty) {
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;

      if (_cameraController.value.isInitialized) {
        await _cameraController.dispose();
      }
      initializeCamera();
    }
  }

  void _initTts() {
    flutterTts.setLanguage("es-ES"); // Idioma español
    flutterTts.setPitch(1.0); // Tono normal
    flutterTts.setSpeechRate(0.5); // Velocidad de lectura moderada
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    flutterTts.stop(); // Detener la reproducción de voz
    _captureTimer?.cancel(); // Cancelar el timer al cerrar la app
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

  Widget _rearCameraView() {
    // Lógica específica para la cámara trasera
    return Transform.rotate(
      angle: math.pi / 2, // Rotación de 90 grados
      child: CameraPreview(_cameraController),
    );
  }

  Widget _frontCameraView() {
    // Lógica específica para la cámara frontal
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi), // Efecto espejo
      child: Transform.rotate(
        angle: -math.pi /
            2, // Ajuste para que la cámara frontal quede correctamente orientada
        child: CameraPreview(_cameraController),
      ),
    );
  }

  Widget _cameraView() {
    // Seleccionar la vista dependiendo de la cámara
    return cameras[selectedCameraIndex].lensDirection ==
            CameraLensDirection.front
        ? _frontCameraView()
        : _rearCameraView();
  }

  void speakText() {
    if (translatedText.isNotEmpty) {
      flutterTts.speak(translatedText);
    }
  }

  void saveTranslation() {
    // Lógica para guardar la traducción (implementar según sea necesario)
    print("Guardado: $translatedText");
  }

  void clearTranslation() {
    setState(() {
      translatedText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Traductor IA',
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
          // Vista de la cámara con tamaño fijo
          SizedBox(
            height: 370, // Altura fija
            width: 350, // Ancho fijo
            child: isCameraInitialized
                ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRect(
                      child: _cameraView(), // Selecciona la vista correcta
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

          // Botón para cambiar cámara
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: switchCamera,
              icon: Icon(Icons.switch_camera),
              label: Text('Cambiar cámara'),
            ),
          ),

          // Campo de texto para traducción
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

                // Botón de reproducir
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    onPressed:
                        speakText, // Llama a la función cuando se presiona
                    label: Text('Reproducir'),
                    icon: Icon(Icons.volume_up_rounded),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 16),

                // Botones de guardar y limpiar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: saveTranslation,
                      child: Text('Guardar'),
                    ),
                    ElevatedButton(
                      onPressed: clearTranslation,
                      child: Text('Limpiar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
