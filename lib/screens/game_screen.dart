import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/progreso_service.dart';
import '../models/progreso.dart';

class GameScreen extends StatefulWidget {
  final int nivel;
  final int juegoId;
  final VoidCallback onLevelComplete;

  const GameScreen(
      {Key? key,
      required this.nivel,
      required this.juegoId,
      required this.onLevelComplete})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> _imagenesCartas;
  late List<bool> _cartasVolteadas;
  int _intentosRestantes = 3;
  String? _primeraCarta;
  int? _primeraCartaIndex;
  Timer? _timer;
  ProgresoService progresoService = ProgresoService();
  int _usuarioId = 0;
  int _nivelActual = 1;

  @override
  void initState() {
    super.initState();
    _cargarProgreso();
    _generarCartas();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Genera las cartas aleatoriamente
  void _generarCartas() {
    List<String> imagenesBase = [
      'a.png',
      'b.png',
      'c.png',
      'd.png',
      'e.png',
      'f.png'
    ]; // Señas en assets/sign/

    imagenesBase.shuffle(); // Mezcla las imágenes
    List<String> cartas = [...imagenesBase.take(3), ...imagenesBase.take(3)];
    cartas.shuffle(); // Mezcla nuevamente

    setState(() {
      _imagenesCartas = cartas;
      _cartasVolteadas = List.generate(cartas.length, (index) => false);
    });
  }

  Future<void> _cargarProgreso() async {
    final prefs = await SharedPreferences.getInstance();
    _usuarioId = prefs.getInt('userId') ?? 0;

    if (_usuarioId != 0) {
      Progreso? progreso =
          await progresoService.obtenerProgreso(_usuarioId, widget.juegoId);
      if (progreso != null) {
        setState(() {
          _nivelActual = progreso.nivelActual;
        });
      } else {
        await progresoService.crearProgreso(_usuarioId, widget.juegoId);
      }
    }
  }

  void _voltearCarta(int index) {
    if (_cartasVolteadas[index] || _primeraCartaIndex == index) return;
    setState(() {
      _cartasVolteadas[index] = true;
    });

    if (_primeraCarta == null) {
      _primeraCarta = _imagenesCartas[index];
      _primeraCartaIndex = index;
    } else {
      if (_primeraCarta == _imagenesCartas[index]) {
        _primeraCarta = null;
        _primeraCartaIndex = null;
        if (_cartasVolteadas.every((volteada) => volteada)) {
          Future.delayed(const Duration(milliseconds: 500), _completarNivel);
        }
      } else {
        _timer = Timer(const Duration(seconds: 1), () {
          setState(() {
            _cartasVolteadas[_primeraCartaIndex!] = false;
            _cartasVolteadas[index] = false;
            _primeraCarta = null;
            _primeraCartaIndex = null;
            _intentosRestantes--;

            if (_intentosRestantes == 0) {
              _mostrarPerdida();
            }
          });
        });
      }
    }
  }

  void _completarNivel() async {
    if (widget.nivel >= _nivelActual) {
      int nuevoNivel = widget.nivel + 1;
      double nuevoProgreso = ((nuevoNivel - 1) / 5) * 100;
      await progresoService.actualizarProgreso(
          _usuarioId, nuevoNivel, nuevoProgreso);
      widget.onLevelComplete();
    }
    _mostrarDialogo("¡Nivel completado!", "Has superado el nivel.");
  }

  void _mostrarPerdida() {
    _mostrarDialogo("¡Perdiste!", "Inténtalo de nuevo.");
  }

  void _mostrarDialogo(String titulo, String mensaje) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Volver"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Encuentra su gemelo",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildIntentos(),
            const SizedBox(height: 20),
            _buildTablero(),
          ],
        ),
      ),
    );
  }

  // Muestra la barra de intentos restantes
  Widget _buildIntentos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Intentos",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: List.generate(3, (index) {
            return Icon(
              index < _intentosRestantes
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            );
          }),
        ),
      ],
    );
  }

  // Construye la cuadrícula del juego
  Widget _buildTablero() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columnas
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _imagenesCartas.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _voltearCarta(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _cartasVolteadas[index]
                  ? Image.asset('assets/sign/${_imagenesCartas[index]}')
                  : const Icon(Icons.help, size: 50, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
