import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicosScreen extends StatefulWidget {
  const MedicosScreen({super.key});

  @override
  State<MedicosScreen> createState() => _MedicosScreenState();
}

class _MedicosScreenState extends State<MedicosScreen> {
  final CollectionReference _medicos = FirebaseFirestore.instance.collection('medicos');

  // Controladores para el formulario
  final _nombreController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _cedulaController = TextEditingController();

  void _showForm([DocumentSnapshot? doc]) {
    if (doc != null) {
      _nombreController.text = doc['nombre'];
      _especialidadController.text = doc['especialidad'];
      _cedulaController.text = doc['cedula'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(doc == null ? "Registrar Médico" : "Editar Médico", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF004A99))),
            TextField(controller: _nombreController, decoration: InputDecoration(labelText: "Nombre Completo")),
            TextField(controller: _especialidadController, decoration: InputDecoration(labelText: "Especialidad")),
            TextField(controller: _cedulaController, decoration: InputDecoration(labelText: "Cédula Profesional")),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF004A99), minimumSize: Size(double.infinity, 50)),
              onPressed: () async {
                if (doc == null) {
                  await _medicos.add({'nombre': _nombreController.text, 'especialidad': _especialidadController.text, 'cedula': _cedulaController.text});
                } else {
                  await _medicos.doc(doc.id).update({'nombre': _nombreController.text, 'especialidad': _especialidadController.text, 'cedula': _cedulaController.text});
                }
                _nombreController.clear(); _especialidadController.clear(); _cedulaController.clear();
                Navigator.pop(context);
              },
              child: Text("GUARDAR", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Directorio de Médicos"), backgroundColor: Color(0xFF004A99), foregroundColor: Colors.white),
      body: StreamBuilder(
        stream: _medicos.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Color(0xFF004A99), child: Icon(Icons.person, color: Colors.white)),
                  title: Text(doc['nombre']),
                  subtitle: Text("${doc['especialidad']} - Céd: ${doc['cedula']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(doc)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _medicos.doc(doc.id).delete()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF004A99),
        onPressed: () => _showForm(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}