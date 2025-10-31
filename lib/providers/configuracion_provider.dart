import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../data/models/configuracion.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

class ConfiguracionProvider extends ChangeNotifier {
  Configuracion _configuracion = Configuracion();
  final _storage = const FlutterSecureStorage();
  final _logger = AppLogger();

  Configuracion get configuracion => _configuracion;

  /// Carga la configuración almacenada
  Future<void> cargarConfiguracion() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Cargar configuración básica
      final dbHost = prefs.getString(AppConstants.keyDatabaseHost) ?? 'api.danteaguerorodriguez.work';
      final dbPort = prefs.getInt(AppConstants.keyDatabasePort) ?? 5432;
      final dbName = prefs.getString(AppConstants.keyDatabaseName) ?? 'posbus_suray';
      final dbUsername = prefs.getString(AppConstants.keyDatabaseUsername) ?? 'posbus_user';

      // Cargar contraseña de almacenamiento seguro
      final dbPassword = await _storage.read(key: AppConstants.keyDatabasePassword) ?? '';

      final autoRefresh = prefs.getBool(AppConstants.keyAutoRefresh) ?? true;
      final refreshInterval = prefs.getInt(AppConstants.keyRefreshInterval) ?? 300;
      final temaOscuro = prefs.getBool(AppConstants.keyThemeMode) ?? false;

      _configuracion = Configuracion(
        dbHost: dbHost,
        dbPort: dbPort,
        dbName: dbName,
        dbUsername: dbUsername,
        dbPassword: dbPassword,
        autoRefresh: autoRefresh,
        refreshInterval: refreshInterval,
        temaOscuro: temaOscuro,
      );

      notifyListeners();
      _logger.info('Configuración cargada correctamente');
    } catch (e, stackTrace) {
      _logger.error('Error al cargar configuración', e, stackTrace);
    }
  }

  /// Guarda la configuración
  Future<void> guardarConfiguracion(Configuracion nuevaConfig) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar configuración básica
      await prefs.setString(AppConstants.keyDatabaseHost, nuevaConfig.dbHost);
      await prefs.setInt(AppConstants.keyDatabasePort, nuevaConfig.dbPort);
      await prefs.setString(AppConstants.keyDatabaseName, nuevaConfig.dbName);
      await prefs.setString(AppConstants.keyDatabaseUsername, nuevaConfig.dbUsername);

      // Guardar contraseña en almacenamiento seguro
      await _storage.write(
        key: AppConstants.keyDatabasePassword,
        value: nuevaConfig.dbPassword,
      );

      await prefs.setBool(AppConstants.keyAutoRefresh, nuevaConfig.autoRefresh);
      await prefs.setInt(AppConstants.keyRefreshInterval, nuevaConfig.refreshInterval);
      await prefs.setBool(AppConstants.keyThemeMode, nuevaConfig.temaOscuro);

      _configuracion = nuevaConfig;
      notifyListeners();

      _logger.info('Configuración guardada correctamente');
    } catch (e, stackTrace) {
      _logger.error('Error al guardar configuración', e, stackTrace);
      rethrow;
    }
  }

  /// Actualiza solo la configuración de base de datos
  Future<void> actualizarConfiguracionDB({
    required String host,
    required int port,
    required String database,
    required String username,
    required String password,
  }) async {
    final nuevaConfig = _configuracion.copyWith(
      dbHost: host,
      dbPort: port,
      dbName: database,
      dbUsername: username,
      dbPassword: password,
    );

    await guardarConfiguracion(nuevaConfig);
  }

  /// Actualiza el tema
  Future<void> actualizarTema(bool oscuro) async {
    final nuevaConfig = _configuracion.copyWith(temaOscuro: oscuro);
    await guardarConfiguracion(nuevaConfig);
  }

  /// Actualiza el intervalo de actualización
  Future<void> actualizarIntervaloRefresh(int segundos) async {
    final nuevaConfig = _configuracion.copyWith(refreshInterval: segundos);
    await guardarConfiguracion(nuevaConfig);
  }

  /// Actualiza auto-refresh
  Future<void> actualizarAutoRefresh(bool habilitado) async {
    final nuevaConfig = _configuracion.copyWith(autoRefresh: habilitado);
    await guardarConfiguracion(nuevaConfig);
  }
}
