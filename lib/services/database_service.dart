import 'package:postgres/postgres.dart';
import '../data/models/cierre_caja.dart';
import '../data/models/transaccion.dart';
import '../data/models/tarifa.dart';
import '../data/models/estadisticas.dart';
import '../config/database_config.dart';
import '../core/utils/logger.dart';

class DatabaseService {
  PostgreSQLConnection? _connection;
  bool _isConnected = false;
  final _logger = AppLogger();

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  bool get isConnected => _isConnected;

  /// Conecta a la base de datos PostgreSQL
  Future<void> conectar({
    required String host,
    required int port,
    required String database,
    required String username,
    required String password,
  }) async {
    try {
      // Si ya hay una conexión activa, desconectar primero
      if (_isConnected && _connection != null) {
        await desconectar();
      }

      _logger.info('Intentando conectar a PostgreSQL: $host:$port/$database');

      _connection = PostgreSQLConnection(
        host,
        port,
        database,
        username: username,
        password: password,
        timeoutInSeconds: DatabaseConstants.defaultTimeout,
        timeZone: 'America/Santiago',
      );

      await _connection!.open();
      _isConnected = true;

      _logger.info('Conexión establecida correctamente con PostgreSQL');
    } catch (e, stackTrace) {
      _isConnected = false;
      _logger.error('Error al conectar con PostgreSQL', e, stackTrace);
      rethrow;
    }
  }

  /// Desconecta de la base de datos
  Future<void> desconectar() async {
    try {
      if (_connection != null && _isConnected) {
        await _connection!.close();
        _isConnected = false;
        _logger.info('Desconectado de PostgreSQL');
      }
    } catch (e, stackTrace) {
      _logger.error('Error al desconectar de PostgreSQL', e, stackTrace);
    }
  }

  /// Prueba la conexión
  Future<bool> probarConexion() async {
    try {
      if (!_isConnected || _connection == null) {
        return false;
      }

      // Ejecutar query simple de prueba
      await _connection!.query('SELECT 1');
      return true;
    } catch (e) {
      _logger.error('Error en prueba de conexión', e);
      return false;
    }
  }

  /// Obtiene todos los cierres
  Future<List<CierreCaja>> obtenerCierres() async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryAllCierres,
      );

      return results.map((row) {
        return CierreCaja.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierres', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene cierres filtrados por rango de fechas
  Future<List<CierreCaja>> obtenerCierresPorRangoFechas({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryCierresByDateRange,
        substitutionValues: {
          'fecha_inicio': fechaInicio.toIso8601String(),
          'fecha_fin': fechaFin.toIso8601String(),
        },
      );

      return results.map((row) {
        return CierreCaja.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierres por rango de fechas', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene cierres por dispositivo
  Future<List<CierreCaja>> obtenerCierresPorDispositivo(String dispositivo) async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryCierresByDispositivo,
        substitutionValues: {
          'dispositivo': dispositivo,
        },
      );

      return results.map((row) {
        return CierreCaja.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierres por dispositivo', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene un cierre por ID
  Future<CierreCaja?> obtenerCierrePorId(int id) async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryCierreById,
        substitutionValues: {
          'id': id,
        },
      );

      if (results.isEmpty) return null;

      return CierreCaja.fromJson(results.first.toColumnMap());
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierre por ID', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene transacciones de un cierre
  Future<List<Transaccion>> obtenerTransaccionesPorCierre(int cierreId) async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryTransaccionesByCierre,
        substitutionValues: {
          'cierre_id': cierreId,
        },
      );

      return results.map((row) {
        return Transaccion.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener transacciones por cierre', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene estadísticas del día
  Future<Estadisticas> obtenerEstadisticasDia({DateTime? fecha}) async {
    try {
      _verificarConexion();

      final fechaConsulta = fecha ?? DateTime.now();

      final results = await _connection!.query(
        DatabaseConstants.queryEstadisticasDia,
        substitutionValues: {
          'fecha': fechaConsulta.toIso8601String(),
        },
      );

      if (results.isEmpty) {
        return Estadisticas(
          totalCierres: 0,
          totalIngresos: 0.0,
          totalTransacciones: 0,
          promedioIngresos: 0.0,
          fecha: fechaConsulta,
        );
      }

      return Estadisticas.fromJson(results.first.toColumnMap());
    } catch (e, stackTrace) {
      _logger.error('Error al obtener estadísticas del día', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene estadísticas por rango de fechas
  Future<List<Estadisticas>> obtenerEstadisticasRango({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryEstadisticasRango,
        substitutionValues: {
          'fecha_inicio': fechaInicio.toIso8601String(),
          'fecha_fin': fechaFin.toIso8601String(),
        },
      );

      return results.map((row) {
        return Estadisticas.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener estadísticas por rango', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene ventas por tipo de pasaje de un cierre
  Future<List<VentaPorTipo>> obtenerVentasPorTipoPasaje(int cierreId) async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryVentasPorTipoPasaje,
        substitutionValues: {
          'cierre_id': cierreId,
        },
      );

      return results.map((row) {
        return VentaPorTipo.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener ventas por tipo de pasaje', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene tarifas activas
  Future<List<Tarifa>> obtenerTarifasActivas() async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryTarifasActivas,
      );

      return results.map((row) {
        return Tarifa.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener tarifas activas', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene tarifas dominicales activas
  Future<List<Tarifa>> obtenerTarifasDomingoActivas() async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        DatabaseConstants.queryTarifasDomingoActivas,
      );

      return results.map((row) {
        return Tarifa.fromJson(row.toColumnMap());
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener tarifas domingo activas', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene lista de dispositivos únicos
  Future<List<String>> obtenerDispositivos() async {
    try {
      _verificarConexion();

      final results = await _connection!.query(
        'SELECT DISTINCT dispositivo_origen FROM ${DatabaseConstants.tableCierresCaja} ORDER BY dispositivo_origen',
      );

      return results.map((row) => row[0] as String).toList();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener dispositivos', e, stackTrace);
      rethrow;
    }
  }

  /// Verifica que la conexión esté activa
  void _verificarConexion() {
    if (!_isConnected || _connection == null) {
      throw Exception('No hay conexión activa con la base de datos');
    }
  }
}
