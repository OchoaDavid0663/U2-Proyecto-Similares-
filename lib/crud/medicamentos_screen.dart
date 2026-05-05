import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';

class MedicamentosScreen extends StatefulWidget {
  const MedicamentosScreen({super.key});
  @override
  State<MedicamentosScreen> createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("Inventario Medicamentos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF004A99),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getMedicamentos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs;
                  return _buildTable(docs);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF004A99),
        onPressed: () => _showFormDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("AGREGAR", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF004A99),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          Icon(Icons.medication, size: 50, color: Colors.white),
          Text("Medicamentos", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTable(List<DocumentSnapshot> docs) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFF004A99).withOpacity(0.1)),
            columns: const [
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Precio')),
              DataColumn(label: Text('Stock')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: docs.map((doc) => DataRow(cells: [
              DataCell(Text(doc['nombre'])),
              DataCell(Text("\$${doc['precio']}")),
              DataCell(Text(doc['stock'].toString())),
              DataCell(Row(
                children: [
                  // BOTÓN VER (READ)
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blue), 
                    onPressed: () => _showViewDialog(context, doc)
                  ),
                  IconButton(icon: const Icon(Icons.edit_note, color: Colors.orange), onPressed: () => _showFormDialog(context, doc: doc)),
                  IconButton(icon: const Icon(Icons.delete_sweep, color: Colors.red), onPressed: () => _firestoreService.deleteMedicamento(doc.id)),
                ],
              )),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  // --- FUNCIÓN PARA VER DETALLES ---
  void _showViewDialog(BuildContext context, DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Detalles del Medicamento", style: TextStyle(color: Color(0xFF004A99), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem("Nombre:", doc['nombre']),
            _detailItem("Sustancia Activa:", doc['sustancia']),
            _detailItem("Precio:", "\$${doc['precio']}"),
            _detailItem("Stock Disponible:", "${doc['stock']} unidades"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CERRAR")),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          children: [
            TextSpan(text: "$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _showFormDialog(BuildContext context, {DocumentSnapshot? doc}) {
    final nomCtrl = TextEditingController(text: doc != null ? doc['nombre'] : "");
    final susCtrl = TextEditingController(text: doc != null ? doc['sustancia'] : "");
    final preCtrl = TextEditingController(text: doc != null ? doc['precio'].toString() : "");
    final stoCtrl = TextEditingController(text: doc != null ? doc['stock'].toString() : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(doc == null ? "Nuevo Medicamento" : "Editar Medicamento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: susCtrl, decoration: const InputDecoration(labelText: "Sustancia")),
            TextField(controller: preCtrl, decoration: const InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
            TextField(controller: stoCtrl, decoration: const InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            onPressed: () {
              final datos = {
                'nombre': nomCtrl.text,
                'sustancia': susCtrl.text,
                'precio': double.parse(preCtrl.text),
                'stock': int.parse(stoCtrl.text),
              };
              if (doc == null) {
                _firestoreService.addMedicamento(nomCtrl.text, susCtrl.text, double.parse(preCtrl.text), int.parse(stoCtrl.text));
              } else {
                _firestoreService.updateMedicamento(doc.id, datos);
              }
              Navigator.pop(context);
            },
            child: Text(doc == null ? "GUARDAR" : "ACTUALIZAR"),
          )
        ],
      ),
    );
  }
}