import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart'; // Nueva pantalla para el registro

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
              child: CircleAvatar(
                radius: 140,
                backgroundImage: AssetImage(
                    'assets/images/logo.png'), // Cambiar al logo que desees
              ),
            ),
            Text(
              "¡Bienvenidoo!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print("boton Login precionado");
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text("Login"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("boton Sing up precionado");
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
