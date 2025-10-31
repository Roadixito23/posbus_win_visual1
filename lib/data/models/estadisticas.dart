class Estadisticas {
  final int totalCierres;
  final double totalIngresos;
  final int totalTransacciones;
  final double promedioIngresos;
  final DateTime? fecha;

  Estadisticas({
    required this.totalCierres,
    required this.totalIngresos,
    required this.totalTransacciones,
    required this.promedioIngresos,
    this.fecha,
  });

  /// Constructor desde JSON (resultado de query)
  factory Estadisticas.fromJson(Map<String, dynamic> json) {
    return Estadisticas(
      totalCierres: _parseInt(json['total_cierres']),
      totalIngresos: _parseDouble(json['total_ingresos']),
      totalTransacciones: _parseInt(json['total_transacciones']),
      promedioIngresos: _parseDouble(json['promedio_ingresos']),
      fecha: json['fecha'] != null
          ? DateTime.tryParse(json['fecha'].toString())
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'total_cierres': totalCierres,
      'total_ingresos': totalIngresos,
      'total_transacciones': totalTransacciones,
      'promedio_ingresos': promedioIngresos,
      'fecha': fecha?.toIso8601String(),
    };
  }

  /// Calcula el promedio por transacción
  double get promedioTransaccion {
    if (totalTransacciones == 0) return 0.0;
    return totalIngresos / totalTransacciones;
  }

  /// Copia con modificaciones
  Estadisticas copyWith({
    int? totalCierres,
    double? totalIngresos,
    int? totalTransacciones,
    double? promedioIngresos,
    DateTime? fecha,
  }) {
    return Estadisticas(
      totalCierres: totalCierres ?? this.totalCierres,
      totalIngresos: totalIngresos ?? this.totalIngresos,
      totalTransacciones: totalTransacciones ?? this.totalTransacciones,
      promedioIngresos: promedioIngresos ?? this.promedioIngresos,
      fecha: fecha ?? this.fecha,
    );
  }

  /// Helper para parsear int desde PostgreSQL
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
    return 'Estadisticas(totalCierres: $totalCierres, totalIngresos: $totalIngresos, totalTransacciones: $totalTransacciones, promedioIngresos: $promedioIngresos, fecha: $fecha)';
  }
}

/// Modelo para comparativa de períodos
class ComparativaEstadisticas {
  final Estadisticas actual;
  final Estadisticas anterior;

  ComparativaEstadisticas({
    required this.actual,
    required this.anterior,
  });

  /// Calcula el cambio porcentual en ingresos
  double get cambioPorcentualIngresos {
    if (anterior.totalIngresos == 0) return 0.0;
    return ((actual.totalIngresos - anterior.totalIngresos) / anterior.totalIngresos) * 100;
  }

  /// Calcula el cambio porcentual en transacciones
  double get cambioPorcentualTransacciones {
    if (anterior.totalTransacciones == 0) return 0.0;
    return ((actual.totalTransacciones - anterior.totalTransacciones) / anterior.totalTransacciones) * 100;
  }

  /// Calcula el cambio porcentual en promedio
  double get cambioPorcentualPromedio {
    if (anterior.promedioIngresos == 0) return 0.0;
    return ((actual.promedioIngresos - anterior.promedioIngresos) / anterior.promedioIngresos) * 100;
  }

  /// Indica si los ingresos mejoraron
  bool get mejoraron => actual.totalIngresos > anterior.totalIngresos;

  /// Diferencia absoluta en ingresos
  double get diferenciaIngresos => actual.totalIngresos - anterior.totalIngresos;

  /// Diferencia absoluta en transacciones
  int get diferenciaTransacciones => actual.totalTransacciones - anterior.totalTransacciones;
}

/// Modelo para ventas por tipo de pasaje
class VentaPorTipo {
  final String nombrePasaje;
  final int cantidad;
  final double total;

  VentaPorTipo({
    required this.nombrePasaje,
    required this.cantidad,
    required this.total,
  });

  /// Constructor desde JSON
  factory VentaPorTipo.fromJson(Map<String, dynamic> json) {
    return VentaPorTipo(
      nombrePasaje: json['nombre_pasaje'] as String,
      cantidad: _parseInt(json['cantidad']),
      total: _parseDouble(json['total']),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre_pasaje': nombrePasaje,
      'cantidad': cantidad,
      'total': total,
    };
  }

  /// Calcula el precio promedio
  double get precioPromedio {
    if (cantidad == 0) return 0.0;
    return total / cantidad;
  }

  /// Helper para parsear int desde PostgreSQL
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
    return 'VentaPorTipo(nombrePasaje: $nombrePasaje, cantidad: $cantidad, total: $total)';
  }
}
