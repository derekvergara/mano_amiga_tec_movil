import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;

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
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[selectedCameraIndex],
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
          // Detectar orientación del dispositivo
          Expanded(
            flex: 3,
            child: isCameraInitialized
                ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRect(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                          cameras[selectedCameraIndex].lensDirection ==
                                  CameraLensDirection.front
                              ? math.pi
                              : 0,
                        ),
                        child: CameraPreview(_cameraController),
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
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    onPressed: speakText,
                    label: Text('Reproducir'),
                    icon: Icon(Icons.play_arrow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
