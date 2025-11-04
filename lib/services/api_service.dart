import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/cierre_caja.dart';
import '../data/models/transaccion.dart';
import '../data/models/tarifa.dart';
import '../core/utils/logger.dart';

/// Servicio para comunicación con la API REST
class ApiService {
  // URL base de la API
  static const String baseUrl = 'https://api.danteaguerorodriguez.work';

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);

  final _logger = AppLogger();

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Headers comunes para todas las peticiones
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Verifica el estado de la API y la conexión a la base de datos
  Future<bool> verificarConexion() async {
    try {
      _logger.info('Verificando conexión con la API: $baseUrl/health');

      final response = await http
          .get(
            Uri.parse('$baseUrl/health'),
            headers: _headers,
          )
          .timeout(connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _logger.info('API respondió correctamente: ${data['status']}');

        // Verificar que la BD también esté conectada
        if (data['database'] != null && data['database'] == 'connected') {
          return true;
        }

        _logger.warning('API responde pero BD no está conectada');
        return false;
      }

      _logger.warning('API respondió con código: ${response.statusCode}');
      return false;
    } catch (e, stackTrace) {
      _logger.error('Error al verificar conexión con API', e, stackTrace);
      return false;
    }
  }

  /// Obtiene información básica de la API
  Future<Map<String, dynamic>?> obtenerInfoAPI() async {
    try {
      final response = await http
          .get(
            Uri.parse(baseUrl),
            headers: _headers,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (e, stackTrace) {
      _logger.error('Error al obtener info de API', e, stackTrace);
      return null;
    }
  }

  /// Obtiene todos los cierres
  /// [skip] - Número de registros a saltar (paginación)
  /// [limit] - Número máximo de registros a retornar
  Future<List<CierreCaja>> obtenerCierres({int skip = 0, int limit = 100}) async {
    try {
      _logger.info('Obteniendo cierres desde API (skip: $skip, limit: $limit)');

      final uri = Uri.parse('$baseUrl/cierres').replace(
        queryParameters: {
          'skip': skip.toString(),
          'limit': limit.toString(),
        },
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final cierres = jsonList.map((json) => CierreCaja.fromJson(json)).toList();
        _logger.info('${cierres.length} cierres obtenidos correctamente');
        return cierres;
      }

      throw Exception('Error al obtener cierres: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierres', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene un cierre por ID
  Future<CierreCaja?> obtenerCierrePorId(int id) async {
    try {
      _logger.info('Obteniendo cierre ID: $id desde API');

      final response = await http
          .get(
            Uri.parse('$baseUrl/cierres/$id'),
            headers: _headers,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CierreCaja.fromJson(jsonData);
      }

      if (response.statusCode == 404) {
        _logger.warning('Cierre con ID $id no encontrado');
        return null;
      }

      throw Exception('Error al obtener cierre: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierre por ID', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene cierres por rango de fechas
  /// [fechaInicio] - Fecha inicial en formato YYYY-MM-DD
  /// [fechaFin] - Fecha final en formato YYYY-MM-DD
  Future<List<CierreCaja>> obtenerCierresPorRangoFechas({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final fechaInicioStr = _formatearFecha(fechaInicio);
      final fechaFinStr = _formatearFecha(fechaFin);

      _logger.info('Obteniendo cierres entre $fechaInicioStr y $fechaFinStr');

      final response = await http
          .get(
            Uri.parse('$baseUrl/cierres/fecha/$fechaInicioStr/$fechaFinStr'),
            headers: _headers,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final cierres = jsonList.map((json) => CierreCaja.fromJson(json)).toList();
        _logger.info('${cierres.length} cierres obtenidos en rango de fechas');
        return cierres;
      }

      throw Exception('Error al obtener cierres por rango: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierres por rango de fechas', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene cierres por dispositivo
  Future<List<CierreCaja>> obtenerCierresPorDispositivo(String dispositivo) async {
    try {
      _logger.info('Obteniendo cierres para dispositivo: $dispositivo');

      final response = await http
          .get(
            Uri.parse('$baseUrl/cierres/dispositivo/$dispositivo'),
            headers: _headers,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final cierres = jsonList.map((json) => CierreCaja.fromJson(json)).toList();
        _logger.info('${cierres.length} cierres obtenidos para dispositivo $dispositivo');
        return cierres;
      }

      throw Exception('Error al obtener cierres por dispositivo: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener cierres por dispositivo', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene transacciones de un cierre específico
  Future<List<Transaccion>> obtenerTransaccionesPorCierre(int cierreId) async {
    try {
      _logger.info('Obteniendo transacciones del cierre ID: $cierreId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/transacciones/cierre/$cierreId'),
            headers: _headers,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final transacciones = jsonList.map((json) => Transaccion.fromJson(json)).toList();
        _logger.info('${transacciones.length} transacciones obtenidas para cierre $cierreId');
        return transacciones;
      }

      throw Exception('Error al obtener transacciones: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener transacciones por cierre', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene tarifas
  /// [activo] - Filtrar solo tarifas activas (true/false/null)
  /// [esDomingo] - Filtrar tarifas de domingo (true/false/null)
  Future<List<Tarifa>> obtenerTarifas({bool? activo, bool? esDomingo}) async {
    try {
      _logger.info('Obteniendo tarifas desde API');

      final queryParams = <String, String>{};
      if (activo != null) {
        queryParams['activo'] = activo.toString();
      }
      if (esDomingo != null) {
        queryParams['es_domingo'] = esDomingo.toString();
      }

      final uri = Uri.parse('$baseUrl/tarifas').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final tarifas = jsonList.map((json) => Tarifa.fromJson(json)).toList();
        _logger.info('${tarifas.length} tarifas obtenidas correctamente');
        return tarifas;
      }

      throw Exception('Error al obtener tarifas: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener tarifas', e, stackTrace);
      rethrow;
    }
  }

  /// Obtiene tarifas activas (helper method)
  Future<List<Tarifa>> obtenerTarifasActivas() async {
    return obtenerTarifas(activo: true);
  }

  /// Obtiene tarifas de domingo activas (helper method)
  Future<List<Tarifa>> obtenerTarifasDomingoActivas() async {
    return obtenerTarifas(activo: true, esDomingo: true);
  }

  /// Obtiene lista de dispositivos únicos
  Future<List<String>> obtenerDispositivos() async {
    try {
      _logger.info('Obteniendo dispositivos desde API');

      final response = await http
          .get(
            Uri.parse('$baseUrl/dispositivos'),
            headers: _headers,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final dispositivos = jsonList.map((item) => item.toString()).toList();
        _logger.info('${dispositivos.length} dispositivos obtenidos');
        return dispositivos;
      }

      throw Exception('Error al obtener dispositivos: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al obtener dispositivos', e, stackTrace);
      rethrow;
    }
  }

  /// Crea un nuevo cierre (POST)
  Future<CierreCaja?> crearCierre(Map<String, dynamic> cierreData) async {
    try {
      _logger.info('Creando nuevo cierre');

      final response = await http
          .post(
            Uri.parse('$baseUrl/cierres'),
            headers: _headers,
            body: json.encode(cierreData),
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        _logger.info('Cierre creado exitosamente');
        return CierreCaja.fromJson(jsonData);
      }

      throw Exception('Error al crear cierre: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al crear cierre', e, stackTrace);
      rethrow;
    }
  }

  /// Crea una nueva transacción (POST)
  Future<Transaccion?> crearTransaccion(Map<String, dynamic> transaccionData) async {
    try {
      _logger.info('Creando nueva transacción');

      final response = await http
          .post(
            Uri.parse('$baseUrl/transacciones'),
            headers: _headers,
            body: json.encode(transaccionData),
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        _logger.info('Transacción creada exitosamente');
        return Transaccion.fromJson(jsonData);
      }

      throw Exception('Error al crear transacción: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.error('Error al crear transacción', e, stackTrace);
      rethrow;
    }
  }

  /// Formatea una fecha a formato YYYY-MM-DD para la API
  String _formatearFecha(DateTime fecha) {
    return fecha.toIso8601String().split('T')[0];
  }
}
