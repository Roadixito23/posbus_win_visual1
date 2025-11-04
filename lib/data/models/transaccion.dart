class Transaccion {
  final int id;
  final String fecha;
  final String hora;
  final String nombrePasaje;
  final double valor;
  final String comprobante;
  final int cierreId;
  final String? dispositivoOrigen;  // Opcional para compatibilidad con API
  final DateTime? sincronizadoEn;

  Transaccion({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.nombrePasaje,
    required this.valor,
    required this.comprobante,
    required this.cierreId,
    this.dispositivoOrigen,  // Ahora opcional
    this.sincronizadoEn,
  });

  /// Constructor desde JSON (API REST o PostgreSQL)
  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      id: json['id'] as int,
      fecha: json['fecha'] as String,
      hora: json['hora'] as String,
      nombrePasaje: json['nombre_pasaje'] as String,
      valor: _parseDouble(json['valor']),
      comprobante: json['comprobante'] as String,
      cierreId: json['cierre_id'] as int,
      dispositivoOrigen: json['dispositivo_origen'] as String?,  // Opcional
      sincronizadoEn: json['sincronizado_en'] != null
          ? DateTime.parse(json['sincronizado_en'].toString())
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'hora': hora,
      'nombre_pasaje': nombrePasaje,
      'valor': valor,
      'comprobante': comprobante,
      'cierre_id': cierreId,
      'dispositivo_origen': dispositivoOrigen,
      'sincronizado_en': sincronizadoEn?.toIso8601String(),
    };
  }

  /// Obtiene la fecha y hora como DateTime
  DateTime? get fechaHoraDateTime {
    try {
      return DateTime.parse('$fecha $hora');
    } catch (e) {
      return null;
    }
  }

  /// Copia con modificaciones
  Transaccion copyWith({
    int? id,
    String? fecha,
    String? hora,
    String? nombrePasaje,
    double? valor,
    String? comprobante,
    int? cierreId,
    String? dispositivoOrigen,
    DateTime? sincronizadoEn,
  }) {
    return Transaccion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      nombrePasaje: nombrePasaje ?? this.nombrePasaje,
      valor: valor ?? this.valor,
      comprobante: comprobante ?? this.comprobante,
      cierreId: cierreId ?? this.cierreId,
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
    return 'Transaccion(id: $id, fecha: $fecha, hora: $hora, nombrePasaje: $nombrePasaje, valor: $valor, comprobante: $comprobante)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaccion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
