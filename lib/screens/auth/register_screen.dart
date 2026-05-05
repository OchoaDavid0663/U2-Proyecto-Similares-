import 'package:flutter/material.dart';
// Subimos dos niveles para llegar a la carpeta services
import '../../services/auth_service.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores de texto para capturar lo que el usuario escribe
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  // Instancia de nuestro servicio de autenticación
  final AuthService _auth = AuthService();

  // Variable para mostrar un indicador de carga
  bool _isRegistering = false;

  @override
  void dispose() {
    // Es muy importante cerrar los controladores al salir de la pantalla
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Cuenta Administrativa"),
        backgroundColor: const Color(0xFF004A99), // Azul Farmacias Similares
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView( 
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Campo de Correo
              TextField(
                controller: _emailController, 
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo Institucional",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF004A99)),
                ),
              ),
              const SizedBox(height: 15),
              // Campo de Contraseña
              TextField(
                controller: _passController, 
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF004A99)),
                ), 
              ),
              const SizedBox(height: 30),
              
              // Botón de Registro
              _isRegistering 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004A99), 
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Por favor rellena todos los campos")),
                      );
                      return;
                    }

                    setState(() => _isRegistering = true);

                    try {
                      // .trim() limpia espacios accidentales al inicio o final del texto
                      await _auth.signUp(
                        _emailController.text.trim(), 
                        _passController.text.trim()
                      );
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("¡Cuenta creada con éxito!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context); // Regresa al Login
                      }
                    } catch (e) {
                      if (mounted) {
                        // Aquí te mostrará el error de "configuration-not-found" si no has activado el correo en Firebase
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: ${e.toString()}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _isRegistering = false);
                    }
                  },
                  child: const Text(
                    "REGISTRAR CUENTA", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}