import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart'; // <--- FALTABA ESTE IMPORT
import 'firebase_options.dart'; 
import 'screens/login_page.dart'; // <--- VERIFICA QUE ESTA RUTA SEA CORRECTA

void main() async {
  // Asegura que los widgets carguen antes de inicializar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase con las opciones generadas por el CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const SimilaresApp());
}

class SimilaresApp extends StatelessWidget {
  const SimilaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Similares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Color azul institucional de Similares
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004A99)), 
        // Aplica la fuente Poppins a toda la aplicación
        textTheme: GoogleFonts.poppinsTextTheme(), 
      ),
      // Pantalla inicial
      home: const LoginPage(), 
    );
  }
}