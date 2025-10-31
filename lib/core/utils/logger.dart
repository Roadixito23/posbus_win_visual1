import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  late Logger _logger;
  File? _logFile;
  bool _initialized = false;

  /// Inicializa el logger
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Obtener directorio de documentos
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/posbus_logs');

      // Crear directorio si no existe
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      // Crear archivo de log con fecha actual
      final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _logFile = File('${logsDir.path}/app-$fecha.log');

      // Configurar logger
      _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: true,
        ),
        output: _FileOutput(_logFile),
      );

      _initialized = true;
      info('Logger inicializado correctamente');
    } catch (e) {
      // Si falla, usar logger simple sin archivo
      _logger = Logger(
        printer: PrettyPrinter(),
      );
      _initialized = true;
    }
  }

  /// Log de depuración
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.d(message, error, stackTrace);
  }

  /// Log de información
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.i(message, error, stackTrace);
  }

  /// Log de advertencia
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.w(message, error, stackTrace);
  }

  /// Log de error
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.e(message, error, stackTrace);
  }

  /// Log fatal
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.f(message, error, stackTrace);
  }

  /// Asegura que el logger está inicializado
  void _ensureInitialized() {
    if (!_initialized) {
      _logger = Logger(printer: SimplePrinter());
    }
  }

  /// Obtiene la ruta del archivo de log actual
  String? getLogFilePath() {
    return _logFile?.path;
  }

  /// Limpia logs antiguos (mantiene últimos N días)
  Future<void> limpiarLogsAntiguos({int diasMantener = 7}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/posbus_logs');

      if (!await logsDir.exists()) return;

      final ahora = DateTime.now();
      final archivos = logsDir.listSync();

      for (var archivo in archivos) {
        if (archivo is File) {
          final stat = await archivo.stat();
          final diferencia = ahora.difference(stat.modified);

          if (diferencia.inDays > diasMantener) {
            await archivo.delete();
            info('Log antiguo eliminado: ${archivo.path}');
          }
        }
      }
    } catch (e) {
      error('Error al limpiar logs antiguos', e);
    }
  }

  /// Obtiene el tamaño total de los logs en MB
  Future<double> obtenerTamanoLogsEnMB() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/posbus_logs');

      if (!await logsDir.exists()) return 0.0;

      int totalBytes = 0;
      final archivos = logsDir.listSync();

      for (var archivo in archivos) {
        if (archivo is File) {
          final stat = await archivo.stat();
          totalBytes += stat.size;
        }
      }

      return totalBytes / (1024 * 1024); // Convertir a MB
    } catch (e) {
      return 0.0;
    }
  }

  /// Elimina todos los logs
  Future<void> eliminarTodosLosLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/posbus_logs');

      if (await logsDir.exists()) {
        await logsDir.delete(recursive: true);
        await logsDir.create();
        info('Todos los logs han sido eliminados');
      }
    } catch (e) {
      error('Error al eliminar logs', e);
    }
  }
}

/// Output personalizado para escribir logs en archivo
class _FileOutput extends LogOutput {
  final File? file;

  _FileOutput(this.file);

  @override
  void output(OutputEvent event) {
    // Imprimir en consola
    for (var line in event.lines) {
      // ignore: avoid_print
      print(line);
    }

    // Escribir en archivo si está disponible
    if (file != null) {
      try {
        final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        final logLines = event.lines.map((line) => '[$timestamp] $line').join('\n');
        file!.writeAsStringSync('$logLines\n', mode: FileMode.append);
      } catch (e) {
        // Silenciosamente ignorar errores de escritura
      }
    }
  }
}
