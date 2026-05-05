import 'package:flutter/material.dart';
import '../../models/souvenir_model.dart';
import '../../services/souvenir_service.dart';

class SouvenirsScreen extends StatefulWidget {
  const SouvenirsScreen({super.key});
  @override
  State<SouvenirsScreen> createState() => _SouvenirsScreenState();
}

class _SouvenirsScreenState extends State<SouvenirsScreen> {
  final SouvenirService _service = SouvenirService();
  final _nomCtrl = TextEditingController();
  final _preCtrl = TextEditingController();
  final _stoCtrl = TextEditingController();
  final _desCtrl = TextEditingController();
  String _cat = 'Peluches';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("Tienda de Souvenirs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<SouvenirModel>>(
                stream: _service.getSouvenirs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return _buildTable(snapshot.data!);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink.shade700,
        onPressed: () => _mostrarFormulario(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("NUEVO", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.pink.shade700,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          Icon(Icons.redeem, size: 50, color: Colors.white),
          Text("Productos Simi", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTable(List<SouvenirModel> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Precio')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: items.map((item) => DataRow(cells: [
              DataCell(Text(item.nombre)),
              DataCell(Text("\$${item.precio}")),
              DataCell(Row(
                children: [
                  // BOTÓN VER (READ)
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blue), 
                    onPressed: () => _mostrarDetalles(item)
                  ),
                  IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _mostrarFormulario(item: item)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _service.deleteSouvenir(item.id!)),
                ],
              )),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  // --- FUNCIÓN PARA VER DETALLES ---
  void _mostrarDetalles(SouvenirModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Información de Producto", style: TextStyle(color: Colors.pink.shade700, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Nombre:", item.nombre),
            _infoRow("Categoría:", item.categoria),
            _infoRow("Precio:", "\$${item.precio}"),
            _infoRow("Stock:", "${item.stock} piezas"),
            const SizedBox(height: 10),
            const Text("Descripción:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(item.descripcion.isEmpty ? "Sin descripción disponible." : item.descripcion),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CERRAR")),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }

  void _mostrarFormulario({SouvenirModel? item}) {
    if (item != null) {
      _nomCtrl.text = item.nombre;
      _preCtrl.text = item.precio.toString();
      _stoCtrl.text = item.stock.toString();
      _desCtrl.text = item.descripcion;
      _cat = item.categoria;
    } else {
      _nomCtrl.clear(); _preCtrl.clear(); _stoCtrl.clear(); _desCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? "Nuevo Producto" : "Editar Producto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nomCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: _preCtrl, decoration: const InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
            TextField(controller: _stoCtrl, decoration: const InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
            TextField(controller: _desCtrl, decoration: const InputDecoration(labelText: "Descripción")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CERRAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade700),
            onPressed: () async {
              final nuevo = SouvenirModel(
                id: item?.id,
                nombre: _nomCtrl.text,
                categoria: _cat,
                precio: double.parse(_preCtrl.text),
                stock: int.parse(_stoCtrl.text),
                descripcion: _desCtrl.text,
              );
              item == null ? await _service.addSouvenir(nuevo) : await _service.updateSouvenir(nuevo);
              if (mounted) Navigator.pop(context);
            },
            child: Text(item == null ? "GUARDAR" : "ACTUALIZAR", style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}