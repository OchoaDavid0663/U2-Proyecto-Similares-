import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recuperar Contraseña")),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text("Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.", 
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            TextField(decoration: InputDecoration(labelText: "Correo Electrónico", border: OutlineInputBorder())),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Enviar enlace de recuperación"),
            )
          ],
        ),
      ),
    );
  }
}