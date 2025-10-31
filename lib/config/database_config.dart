class DatabaseConstants {
  // Nombres de tablas
  static const String tableCierresCaja = 'cierres_caja';
  static const String tableTransacciones = 'transacciones';
  static const String tableTarifas = 'tarifas';
  static const String tableTarifasDomingo = 'tarifas_domingo';

  // Columnas cierres_caja
  static const String columnId = 'id';
  static const String columnFechaCierre = 'fecha_cierre';
  static const String columnTotalIngresos = 'total_ingresos';
  static const String columnTotalTransacciones = 'total_transacciones';
  static const String columnPdfPath = 'pdf_path';
  static const String columnDispositivoOrigen = 'dispositivo_origen';
  static const String columnSincronizadoEn = 'sincronizado_en';

  // Columnas transacciones
  static const String columnFecha = 'fecha';
  static const String columnHora = 'hora';
  static const String columnNombrePasaje = 'nombre_pasaje';
  static const String columnValor = 'valor';
  static const String columnComprobante = 'comprobante';
  static const String columnCierreId = 'cierre_id';

  // Columnas tarifas
  static const String columnNombre = 'nombre';
  static const String columnPrecio = 'precio';
  static const String columnOrden = 'orden';
  static const String columnActivo = 'activo';
  static const String columnActualizadoEn = 'actualizado_en';

  // Queries predefinidas
  static const String queryAllCierres = '''
    SELECT * FROM $tableCierresCaja
    ORDER BY fecha_cierre DESC
  ''';

  static const String queryCierreById = '''
    SELECT * FROM $tableCierresCaja
    WHERE id = @id
  ''';

  static const String queryCierresByDateRange = '''
    SELECT * FROM $tableCierresCaja
    WHERE fecha_cierre >= @fecha_inicio
    AND fecha_cierre <= @fecha_fin
    ORDER BY fecha_cierre DESC
  ''';

  static const String queryCierresByDispositivo = '''
    SELECT * FROM $tableCierresCaja
    WHERE dispositivo_origen = @dispositivo
    ORDER BY fecha_cierre DESC
  ''';

  static const String queryTransaccionesByCierre = '''
    SELECT * FROM $tableTransacciones
    WHERE cierre_id = @cierre_id
    ORDER BY hora ASC
  ''';

  static const String queryEstadisticasDia = '''
    SELECT
      COUNT(*) as total_cierres,
      SUM(total_ingresos) as total_ingresos,
      SUM(total_transacciones) as total_transacciones,
      AVG(total_ingresos) as promedio_ingresos
    FROM $tableCierresCaja
    WHERE DATE(fecha_cierre) = DATE(@fecha)
  ''';

  static const String queryEstadisticasRango = '''
    SELECT
      COUNT(*) as total_cierres,
      SUM(total_ingresos) as total_ingresos,
      SUM(total_transacciones) as total_transacciones,
      AVG(total_ingresos) as promedio_ingresos,
      DATE(fecha_cierre) as fecha
    FROM $tableCierresCaja
    WHERE fecha_cierre >= @fecha_inicio
    AND fecha_cierre <= @fecha_fin
    GROUP BY DATE(fecha_cierre)
    ORDER BY fecha DESC
  ''';

  static const String queryVentasPorTipoPasaje = '''
    SELECT
      nombre_pasaje,
      COUNT(*) as cantidad,
      SUM(valor) as total
    FROM $tableTransacciones
    WHERE cierre_id = @cierre_id
    GROUP BY nombre_pasaje
    ORDER BY total DESC
  ''';

  static const String queryTarifasActivas = '''
    SELECT * FROM $tableTarifas
    WHERE activo = 1
    ORDER BY orden ASC
  ''';

  static const String queryTarifasDomingoActivas = '''
    SELECT * FROM $tableTarifasDomingo
    WHERE activo = 1
    ORDER BY orden ASC
  ''';

  // Configuración de conexión por defecto
  static const String defaultHost = 'api.danteaguerorodriguez.work';
  static const int defaultPort = 5432;
  static const String defaultDatabase = 'posbus_suray';
  static const String defaultUsername = 'posbus_user';
  static const int defaultTimeout = 30;

  // Configuración de caché local
  static const String localDatabaseName = 'posbus_cache.db';
  static const int localDatabaseVersion = 1;
  static const int maxCacheSize = 100;

  // Configuración de sincronización
  static const int defaultSyncInterval = 300; // 5 minutos
  static const int minSyncInterval = 60; // 1 minuto
  static const int maxSyncInterval = 3600; // 1 hora
  static const int reconnectionDelay = 30; // 30 segundos
  static const int maxReconnectionAttempts = 5;
}
