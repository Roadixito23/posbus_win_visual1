class AppConstants {
  // Información de la aplicación
  static const String appName = 'POSBUS Suray - Visualizador';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Visualizador de Cierres de Caja para Sistema POSBUS';

  // Rutas de navegación
  static const String routeHome = '/';
  static const String routeCierres = '/cierres';
  static const String routeDetalle = '/detalle';
  static const String routeEstadisticas = '/estadisticas';
  static const String routeConfiguracion = '/configuracion';

  // Configuración de UI
  static const double sidebarWidth = 250.0;
  static const double minWindowWidth = 800.0;
  static const double minWindowHeight = 600.0;
  static const double defaultWindowWidth = 1280.0;
  static const double defaultWindowHeight = 720.0;

  // Configuración de paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Configuración de actualización
  static const int minRefreshInterval = 60; // segundos
  static const int defaultRefreshInterval = 300; // 5 minutos
  static const int maxRefreshInterval = 3600; // 1 hora

  // Configuración de caché
  static const int defaultCacheSize = 100;
  static const int maxCacheSize = 500;
  static const Duration cacheExpiration = Duration(hours: 24);

  // Configuración de exportación
  static const String defaultExportFolder = 'exports';
  static const String excelExtension = '.xlsx';
  static const String pdfExtension = '.pdf';

  // Formatos de fecha
  static const String dateFormatLong = 'dd/MM/yyyy HH:mm:ss';
  static const String dateFormatShort = 'dd/MM/yyyy';
  static const String dateFormatTime = 'HH:mm:ss';
  static const String dateFormatMonthYear = 'MMMM yyyy';

  // Formatos de moneda
  static const String currencySymbol = '\$';
  static const String currencyFormat = 'CLP';
  static const int currencyDecimals = 0;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration queryTimeout = Duration(seconds: 60);
  static const Duration retryDelay = Duration(seconds: 5);
  static const int maxRetries = 3;

  // Mensajes de usuario
  static const String msgConnectionSuccess = 'Conexión establecida correctamente';
  static const String msgConnectionError = 'Error al conectar con el servidor';
  static const String msgNoData = 'No hay datos disponibles';
  static const String msgLoadingData = 'Cargando datos...';
  static const String msgExportSuccess = 'Exportación completada';
  static const String msgExportError = 'Error al exportar';
  static const String msgUpdateAvailable = 'Nuevos datos disponibles';

  // Claves de almacenamiento
  static const String keyDatabaseHost = 'db_host';
  static const String keyDatabasePort = 'db_port';
  static const String keyDatabaseName = 'db_name';
  static const String keyDatabaseUsername = 'db_username';
  static const String keyDatabasePassword = 'db_password';
  static const String keyThemeMode = 'theme_mode';
  static const String keyAutoRefresh = 'auto_refresh';
  static const String keyRefreshInterval = 'refresh_interval';
  static const String keyLastSync = 'last_sync';

  // Estadísticas
  static const String periodToday = 'today';
  static const String periodWeek = 'week';
  static const String periodMonth = 'month';
  static const String periodCustom = 'custom';

  // Estados de conexión
  static const String statusConnected = 'connected';
  static const String statusDisconnected = 'disconnected';
  static const String statusConnecting = 'connecting';
  static const String statusError = 'error';
}
