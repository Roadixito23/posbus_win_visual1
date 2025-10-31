class CierreCaja {
  final int id;
  final String fechaCierre;
  final double totalIngresos;
  final int totalTransacciones;
  final String? pdfPath;
  final String dispositivoOrigen;
  final DateTime? sincronizadoEn;

  CierreCaja({
    required this.id,
    required this.fechaCierre,
    required this.totalIngresos,
    required this.totalTransacciones,
    this.pdfPath,
    required this.dispositivoOrigen,
    this.sincronizadoEn,
  });

  /// Constructor desde JSON (PostgreSQL)
  factory CierreCaja.fromJson(Map<String, dynamic> json) {
    return CierreCaja(
      id: json['id'] as int,
      fechaCierre: json['fecha_cierre'] as String,
      totalIngresos: _parseDouble(json['total_ingresos']),
      totalTransacciones: json['total_transacciones'] as int,
      pdfPath: json['pdf_path'] as String?,
      dispositivoOrigen: json['dispositivo_origen'] as String,
      sincronizadoEn: json['sincronizado_en'] != null
          ? DateTime.parse(json['sincronizado_en'].toString())
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_cierre': fechaCierre,
      'total_ingresos': totalIngresos,
      'total_transacciones': totalTransacciones,
      'pdf_path': pdfPath,
      'dispositivo_origen': dispositivoOrigen,
      'sincronizado_en': sincronizadoEn?.toIso8601String(),
    };
  }

  /// Calcula el promedio por transacción
  double get promedioTransaccion {
    if (totalTransacciones == 0) return 0.0;
    return totalIngresos / totalTransacciones;
  }

  /// Obtiene la fecha como DateTime
  DateTime? get fechaDateTime {
    try {
      return DateTime.parse(fechaCierre);
    } catch (e) {
      return null;
    }
  }

  /// Copia con modificaciones
  CierreCaja copyWith({
    int? id,
    String? fechaCierre,
    double? totalIngresos,
    int? totalTransacciones,
    String? pdfPath,
    String? dispositivoOrigen,
    DateTime? sincronizadoEn,
  }) {
    return CierreCaja(
      id: id ?? this.id,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      totalIngresos: totalIngresos ?? this.totalIngresos,
      totalTransacciones: totalTransacciones ?? this.totalTransacciones,
      pdfPath: pdfPath ?? this.pdfPath,
      dispositivoOrigen: dispositivoOrigen ?? this.dispositivoOrigen,
      sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
    );
  }

  /// Helper para parsear double desde PostgreSQL
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() {
    return 'CierreCaja(id: $id, fechaCierre: $fechaCierre, totalIngresos: $totalIngresos, totalTransacciones: $totalTransacciones, dispositivoOrigen: $dispositivoOrigen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CierreCaja && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
