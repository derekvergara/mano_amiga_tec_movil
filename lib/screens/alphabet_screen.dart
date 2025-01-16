import 'package:flutter/material.dart';

class AlphabetScreen extends StatelessWidget {
  final String title;

  const AlphabetScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          "Pantalla de $title",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
