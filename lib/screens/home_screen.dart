import 'package:flutter/material.dart';
// Asegúrate de que estas rutas sean las correctas en tu proyecto
import '../crud/medicamentos_screen.dart'; 
import '../crud/souvenirs_screen.dart'; // Importamos la nueva pantalla

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Panel Administrativo Similares", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF004A99),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenido, Administrador", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            const Text("Seleccione una categoría para gestionar el inventario:"),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2,
                children: [
                  // TARJETA DE MEDICAMENTOS
                  _buildCategoryCard(
                    context,
                    "Medicamentos",
                    Icons.medication,
                    const Color(0xFF004A99),
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicamentosScreen())),
                  ),
                  
                  // TARJETA DE PRODUCTOS (SOUVENIRS)
                  _buildCategoryCard(
                    context,
                    "Productos", // Nombre cambiado
                    Icons.redeem, // Icono de regalo/souvenir
                    Colors.pink.shade600, // Color distintivo para souvenirs
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SouvenirsScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3), 
              blurRadius: 10, 
              offset: const Offset(0, 5)
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title, 
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}