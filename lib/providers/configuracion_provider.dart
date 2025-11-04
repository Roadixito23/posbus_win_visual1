import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

class ConfiguracionProvider extends ChangeNotifier {
  final _apiService = ApiService();
  final _logger = AppLogger();

  // Configuraciones de la aplicación
  bool _temaOscuro = false;
  bool _autoRefresh = true;
  int _refreshInterval = 300; // segundos
  bool _isConnected = false;

  // Getters
  bool get temaOscuro => _temaOscuro;
  bool get autoRefresh => _autoRefresh;
  int get refreshInterval => _refreshInterval;
  bool get isConnected => _isConnected;

  /// Carga la configuración almacenada
  Future<void> cargarConfiguracion() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _autoRefresh = prefs.getBool(AppConstants.keyAutoRefresh) ?? true;
      _refreshInterval = prefs.getInt(AppConstants.keyRefreshInterval) ?? 300;
      _temaOscuro = prefs.getBool(AppConstants.keyThemeMode) ?? false;

      notifyListeners();
      _logger.info('Configuración cargada correctamente');

      // Verificar conexión con la API al cargar
      await verificarConexionAPI();
    } catch (e, stackTrace) {
      _logger.error('Error al cargar configuración', e, stackTrace);
    }
  }

  /// Verifica la conexión con la API REST
  Future<bool> verificarConexionAPI() async {
    try {
      _logger.info('Verificando conexión con API REST');
      _isConnected = await _apiService.verificarConexion();

      notifyListeners();

      if (_isConnected) {
        _logger.info('Conexión con API establecida correctamente');
      } else {
        _logger.warning('No se pudo conectar con la API');
      }

      return _isConnected;
    } catch (e, stackTrace) {
      _logger.error('Error al verificar conexión con API', e, stackTrace);
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  /// Obtiene información de la API
  Future<Map<String, dynamic>?> obtenerInfoAPI() async {
    try {
      return await _apiService.obtenerInfoAPI();
    } catch (e, stackTrace) {
      _logger.error('Error al obtener información de API', e, stackTrace);
      return null;
    }
  }

  /// Actualiza el tema
  Future<void> actualizarTema(bool oscuro) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyThemeMode, oscuro);

      _temaOscuro = oscuro;
      notifyListeners();

      _logger.info('Tema actualizado: ${oscuro ? 'oscuro' : 'claro'}');
    } catch (e, stackTrace) {
      _logger.error('Error al actualizar tema', e, stackTrace);
      rethrow;
    }
  }

  /// Actualiza el intervalo de actualización
  Future<void> actualizarIntervaloRefresh(int segundos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyRefreshInterval, segundos);

      _refreshInterval = segundos;
      notifyListeners();

      _logger.info('Intervalo de actualización cambiado a $segundos segundos');
    } catch (e, stackTrace) {
      _logger.error('Error al actualizar intervalo', e, stackTrace);
      rethrow;
    }
  }

  /// Actualiza auto-refresh
  Future<void> actualizarAutoRefresh(bool habilitado) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyAutoRefresh, habilitado);

      _autoRefresh = habilitado;
      notifyListeners();

      _logger.info('Auto-refresh ${habilitado ? 'habilitado' : 'deshabilitado'}');
    } catch (e, stackTrace) {
      _logger.error('Error al actualizar auto-refresh', e, stackTrace);
      rethrow;
    }
  }
}
