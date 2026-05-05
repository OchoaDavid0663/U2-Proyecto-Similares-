class SouvenirModel {
  String? id;
  String nombre;
  String categoria; // Ejemplo: Peluches, Ropa, Accesorios
  double precio;
  int stock;
  String descripcion;

  SouvenirModel({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.descripcion,
  });

  // Convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'precio': precio,
      'stock': stock,
      'descripcion': descripcion,
    };
  }

  // Crear objeto desde Firebase
  factory SouvenirModel.fromMap(Map<String, dynamic> map, String id) {
    return SouvenirModel(
      id: id,
      nombre: map['nombre'] ?? '',
      categoria: map['categoria'] ?? '',
      precio: (map['precio'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
      descripcion: map['descripcion'] ?? '',
    );
  }
}