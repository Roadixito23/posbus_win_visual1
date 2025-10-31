class Tarifa {
  final int id;
  final String nombre;
  final double precio;
  final int orden;
  final bool activo;
  final DateTime? actualizadoEn;

  Tarifa({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.orden,
    required this.activo,
    this.actualizadoEn,
  });

  /// Constructor desde JSON (PostgreSQL)
  factory Tarifa.fromJson(Map<String, dynamic> json) {
    return Tarifa(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      precio: _parseDouble(json['precio']),
      orden: json['orden'] as int,
      activo: _parseBool(json['activo']),
      actualizadoEn: json['actualizado_en'] != null
          ? DateTime.parse(json['actualizado_en'].toString())
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'orden': orden,
      'activo': activo ? 1 : 0,
      'actualizado_en': actualizadoEn?.toIso8601String(),
    };
  }

  /// Copia con modificaciones
  Tarifa copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? orden,
    bool? activo,
    DateTime? actualizadoEn,
  }) {
    return Tarifa(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      orden: orden ?? this.orden,
      activo: activo ?? this.activo,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  /// Helper para parsear double desde PostgreSQL
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Helper para parsear bool desde PostgreSQL (1/0)
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  @override
  String toString() {
    return 'Tarifa(id: $id, nombre: $nombre, precio: $precio, orden: $orden, activo: $activo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tarifa && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
