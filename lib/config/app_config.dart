import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final DatabaseConfig database;
  final AppSettings appSettings;
  final ExportConfig export;

  AppConfig({
    required this.database,
    required this.appSettings,
    required this.export,
  });

  static Future<AppConfig> loadConfig() async {
    try {
      final configString = await rootBundle.loadString('assets/config/app_config.json');
      final configJson = json.decode(configString);

      return AppConfig(
        database: DatabaseConfig.fromJson(configJson['databaseConnection'] ?? {}),
        appSettings: AppSettings.fromJson(configJson['appSettings'] ?? {}),
        export: ExportConfig.fromJson(configJson['export'] ?? {}),
      );
    } catch (e) {
      // Si el archivo no existe, retornar configuración por defecto
      return AppConfig.defaultConfig();
    }
  }

  static AppConfig defaultConfig() {
    return AppConfig(
      database: DatabaseConfig.defaultConfig(),
      appSettings: AppSettings.defaultSettings(),
      export: ExportConfig.defaultConfig(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'databaseConnection': database.toJson(),
      'appSettings': appSettings.toJson(),
      'export': export.toJson(),
    };
  }
}

class DatabaseConfig {
  final String host;
  final int port;
  final String database;
  final String username;
  final String password;
  final String sslMode;
  final int timeout;

  DatabaseConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
    this.sslMode = 'prefer',
    this.timeout = 30,
  });

  factory DatabaseConfig.fromJson(Map<String, dynamic> json) {
    return DatabaseConfig(
      host: json['host'] ?? 'api.danteaguerorodriguez.work',
      port: json['port'] ?? 5432,
      database: json['database'] ?? 'posbus_suray',
      username: json['username'] ?? 'posbus_user',
      password: json['password'] ?? '',
      sslMode: json['sslMode'] ?? 'prefer',
      timeout: json['timeout'] ?? 30,
    );
  }

  static DatabaseConfig defaultConfig() {
    return DatabaseConfig(
      host: 'api.danteaguerorodriguez.work',
      port: 5432,
      database: 'posbus_suray',
      username: 'posbus_user',
      password: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'database': database,
      'username': username,
      'password': password,
      'sslMode': sslMode,
      'timeout': timeout,
    };
  }

  DatabaseConfig copyWith({
    String? host,
    int? port,
    String? database,
    String? username,
    String? password,
    String? sslMode,
    int? timeout,
  }) {
    return DatabaseConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      database: database ?? this.database,
      username: username ?? this.username,
      password: password ?? this.password,
      sslMode: sslMode ?? this.sslMode,
      timeout: timeout ?? this.timeout,
    );
  }
}

class AppSettings {
  final int autoRefreshInterval;
  final String theme;
  final int cacheSize;
  final String dateFormat;
  final String currencyFormat;

  AppSettings({
    this.autoRefreshInterval = 300,
    this.theme = 'light',
    this.cacheSize = 100,
    this.dateFormat = 'dd/MM/yyyy',
    this.currencyFormat = 'CLP',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      autoRefreshInterval: json['autoRefreshInterval'] ?? 300,
      theme: json['theme'] ?? 'light',
      cacheSize: json['cacheSize'] ?? 100,
      dateFormat: json['dateFormat'] ?? 'dd/MM/yyyy',
      currencyFormat: json['currencyFormat'] ?? 'CLP',
    );
  }

  static AppSettings defaultSettings() {
    return AppSettings();
  }

  Map<String, dynamic> toJson() {
    return {
      'autoRefreshInterval': autoRefreshInterval,
      'theme': theme,
      'cacheSize': cacheSize,
      'dateFormat': dateFormat,
      'currencyFormat': currencyFormat,
    };
  }

  AppSettings copyWith({
    int? autoRefreshInterval,
    String? theme,
    int? cacheSize,
    String? dateFormat,
    String? currencyFormat,
  }) {
    return AppSettings(
      autoRefreshInterval: autoRefreshInterval ?? this.autoRefreshInterval,
      theme: theme ?? this.theme,
      cacheSize: cacheSize ?? this.cacheSize,
      dateFormat: dateFormat ?? this.dateFormat,
      currencyFormat: currencyFormat ?? this.currencyFormat,
    );
  }
}

class ExportConfig {
  final String defaultExportPath;

  ExportConfig({
    this.defaultExportPath = 'exports/',
  });

  factory ExportConfig.fromJson(Map<String, dynamic> json) {
    return ExportConfig(
      defaultExportPath: json['defaultExportPath'] ?? 'exports/',
    );
  }

  static ExportConfig defaultConfig() {
    return ExportConfig();
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultExportPath': defaultExportPath,
    };
  }
}
