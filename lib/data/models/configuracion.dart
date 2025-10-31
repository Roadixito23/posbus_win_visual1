class Configuracion {
  final String dbHost;
  final int dbPort;
  final String dbName;
  final String dbUsername;
  final String dbPassword;
  final bool autoRefresh;
  final int refreshInterval;
  final bool temaOscuro;
  final String formatoMoneda;
  final String formatoFecha;

  Configuracion({
    this.dbHost = 'api.danteaguerorodriguez.work',
    this.dbPort = 5432,
    this.dbName = 'posbus_suray',
    this.dbUsername = 'posbus_user',
    this.dbPassword = '',
    this.autoRefresh = true,
    this.refreshInterval = 300,
    this.temaOscuro = false,
    this.formatoMoneda = 'CLP',
    this.formatoFecha = 'dd/MM/yyyy',
  });

  /// Constructor desde JSON
  factory Configuracion.fromJson(Map<String, dynamic> json) {
    return Configuracion(
      dbHost: json['db_host'] as String? ?? 'api.danteaguerorodriguez.work',
      dbPort: json['db_port'] as int? ?? 5432,
      dbName: json['db_name'] as String? ?? 'posbus_suray',
      dbUsername: json['db_username'] as String? ?? 'posbus_user',
      dbPassword: json['db_password'] as String? ?? '',
      autoRefresh: json['auto_refresh'] as bool? ?? true,
      refreshInterval: json['refresh_interval'] as int? ?? 300,
      temaOscuro: json['tema_oscuro'] as bool? ?? false,
      formatoMoneda: json['formato_moneda'] as String? ?? 'CLP',
      formatoFecha: json['formato_fecha'] as String? ?? 'dd/MM/yyyy',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'db_host': dbHost,
      'db_port': dbPort,
      'db_name': dbName,
      'db_username': dbUsername,
      'db_password': dbPassword,
      'auto_refresh': autoRefresh,
      'refresh_interval': refreshInterval,
      'tema_oscuro': temaOscuro,
      'formato_moneda': formatoMoneda,
      'formato_fecha': formatoFecha,
    };
  }

  /// Copia con modificaciones
  Configuracion copyWith({
    String? dbHost,
    int? dbPort,
    String? dbName,
    String? dbUsername,
    String? dbPassword,
    bool? autoRefresh,
    int? refreshInterval,
    bool? temaOscuro,
    String? formatoMoneda,
    String? formatoFecha,
  }) {
    return Configuracion(
      dbHost: dbHost ?? this.dbHost,
      dbPort: dbPort ?? this.dbPort,
      dbName: dbName ?? this.dbName,
      dbUsername: dbUsername ?? this.dbUsername,
      dbPassword: dbPassword ?? this.dbPassword,
      autoRefresh: autoRefresh ?? this.autoRefresh,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      temaOscuro: temaOscuro ?? this.temaOscuro,
      formatoMoneda: formatoMoneda ?? this.formatoMoneda,
      formatoFecha: formatoFecha ?? this.formatoFecha,
    );
  }

  /// Valida si la configuración de BD está completa
  bool get configuracionDbCompleta {
    return dbHost.isNotEmpty &&
           dbPort > 0 &&
           dbName.isNotEmpty &&
           dbUsername.isNotEmpty;
  }

  /// Obtiene la cadena de conexión
  String get connectionString {
    return 'postgres://$dbUsername:***@$dbHost:$dbPort/$dbName';
  }

  @override
  String toString() {
    return 'Configuracion(dbHost: $dbHost, dbPort: $dbPort, dbName: $dbName, dbUsername: $dbUsername, autoRefresh: $autoRefresh, refreshInterval: $refreshInterval, temaOscuro: $temaOscuro)';
  }
}

/// Modelo para el estado de conexión
class EstadoConexion {
  final bool conectado;
  final String mensaje;
  final DateTime? ultimaConexion;
  final DateTime? ultimaSincronizacion;

  EstadoConexion({
    required this.conectado,
    this.mensaje = '',
    this.ultimaConexion,
    this.ultimaSincronizacion,
  });

  /// Constructor para estado conectado
  factory EstadoConexion.conectado({DateTime? ultimaSincronizacion}) {
    return EstadoConexion(
      conectado: true,
      mensaje: 'Conectado',
      ultimaConexion: DateTime.now(),
      ultimaSincronizacion: ultimaSincronizacion,
    );
  }

  /// Constructor para estado desconectado
  factory EstadoConexion.desconectado({String? mensaje}) {
    return EstadoConexion(
      conectado: false,
      mensaje: mensaje ?? 'Desconectado',
    );
  }

  /// Constructor para estado de error
  factory EstadoConexion.error(String mensaje) {
    return EstadoConexion(
      conectado: false,
      mensaje: mensaje,
    );
  }

  /// Copia con modificaciones
  EstadoConexion copyWith({
    bool? conectado,
    String? mensaje,
    DateTime? ultimaConexion,
    DateTime? ultimaSincronizacion,
  }) {
    return EstadoConexion(
      conectado: conectado ?? this.conectado,
      mensaje: mensaje ?? this.mensaje,
      ultimaConexion: ultimaConexion ?? this.ultimaConexion,
      ultimaSincronizacion: ultimaSincronizacion ?? this.ultimaSincronizacion,
    );
  }
}
