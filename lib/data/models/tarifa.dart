class Tarifa {
  final int id;
  final String nombre;
  final double precio;  // Mantener como "precio" internamente
  final int? orden;  // Opcional para compatibilidad con API
  final bool activo;
  final bool? esDomingo;  // Nuevo campo para compatibilidad con API
  final DateTime? actualizadoEn;

  Tarifa({
    required this.id,
    required this.nombre,
    required this.precio,
    this.orden,  // Ahora opcional
    required this.activo,
    this.esDomingo,  // Nuevo campo opcional
    this.actualizadoEn,
  });

  /// Constructor desde JSON (API REST o PostgreSQL)
  factory Tarifa.fromJson(Map<String, dynamic> json) {
    return Tarifa(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      // La API usa 'valor', PostgreSQL puede usar 'precio'
      precio: _parseDouble(json['valor'] ?? json['precio']),
      orden: json['orden'] as int?,  // Opcional
      activo: _parseBool(json['activo']),
      esDomingo: json['es_domingo'] != null ? _parseBool(json['es_domingo']) : null,
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
      'valor': precio,  // La API espera 'valor'
      'precio': precio,  // Mantener por compatibilidad
      if (orden != null) 'orden': orden,
      'activo': activo,
      if (esDomingo != null) 'es_domingo': esDomingo,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn?.toIso8601String(),
    };
  }

  /// Copia con modificaciones
  Tarifa copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? orden,
    bool? activo,
    bool? esDomingo,
    DateTime? actualizadoEn,
  }) {
    return Tarifa(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      orden: orden ?? this.orden,
      activo: activo ?? this.activo,
      esDomingo: esDomingo ?? this.esDomingo,
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
    return 'Tarifa(id: $id, nombre: $nombre, precio: $precio, orden: $orden, activo: $activo, esDomingo: $esDomingo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tarifa && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
