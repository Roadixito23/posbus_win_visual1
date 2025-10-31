import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import '../data/models/cierre_caja.dart';
import '../data/models/transaccion.dart';
import '../core/utils/currency_helper.dart';
import '../core/utils/date_time_helper.dart';
import '../core/utils/logger.dart';

class ExportService {
  final _logger = AppLogger();

  /// Exporta un cierre y sus transacciones a Excel
  Future<String> exportarCierreExcel(
    CierreCaja cierre,
    List<Transaccion> transacciones,
  ) async {
    try {
      _logger.info('Exportando cierre ${cierre.id} a Excel');

      final excel = Excel.createExcel();

      // Eliminar hoja por defecto
      excel.delete('Sheet1');

      // Crear hoja de resumen
      final resumenSheet = excel['Resumen'];
      _crearHojaResumen(resumenSheet, cierre);

      // Crear hoja de transacciones
      final transaccionesSheet = excel['Transacciones'];
      _crearHojaTransacciones(transaccionesSheet, transacciones);

      // Guardar archivo
      final path = await _guardarExcel(excel, 'cierre_${cierre.id}');
      _logger.info('Cierre exportado a: $path');

      return path;
    } catch (e, stackTrace) {
      _logger.error('Error al exportar cierre a Excel', e, stackTrace);
      rethrow;
    }
  }

  /// Exporta una lista de cierres a Excel
  Future<String> exportarListaCierresExcel(List<CierreCaja> cierres) async {
    try {
      _logger.info('Exportando lista de ${cierres.length} cierres a Excel');

      final excel = Excel.createExcel();
      excel.delete('Sheet1');

      final sheet = excel['Cierres'];

      // Headers
      sheet.appendRow([
        'ID',
        'Fecha Cierre',
        'Total Ingresos',
        'Total Transacciones',
        'Promedio',
        'Dispositivo',
        'Sincronizado En',
      ]);

      // Datos
      for (var cierre in cierres) {
        sheet.appendRow([
          cierre.id,
          DateTimeHelper.formatearFecha(cierre.fechaCierre),
          CurrencyHelper.formatearCLP(cierre.totalIngresos),
          cierre.totalTransacciones,
          CurrencyHelper.formatearCLP(cierre.promedioTransaccion),
          cierre.dispositivoOrigen,
          cierre.sincronizadoEn != null
              ? DateTimeHelper.formatearFecha(cierre.sincronizadoEn.toString())
              : '-',
        ]);
      }

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path = await _guardarExcel(excel, 'cierres_$timestamp');
      _logger.info('Lista de cierres exportada a: $path');

      return path;
    } catch (e, stackTrace) {
      _logger.error('Error al exportar lista de cierres', e, stackTrace);
      rethrow;
    }
  }

  /// Exporta un cierre a PDF
  Future<String> exportarCierrePDF(
    CierreCaja cierre,
    List<Transaccion> transacciones,
  ) async {
    try {
      _logger.info('Exportando cierre ${cierre.id} a PDF');

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            // Header
            pw.Header(
              level: 0,
              child: pw.Text(
                'Cierre de Caja #${cierre.id}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            // Información del cierre
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Fecha de Cierre:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(DateTimeHelper.formatearFecha(cierre.fechaCierre)),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Ingresos:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        CurrencyHelper.formatearCLP(cierre.totalIngresos),
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Transacciones:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('${cierre.totalTransacciones}'),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Dispositivo:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(cierre.dispositivoOrigen),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Tabla de transacciones
            pw.Text(
              'Transacciones',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              headers: ['Hora', 'Pasaje', 'Valor', 'Comprobante'],
              data: transacciones.map((t) => [
                DateTimeHelper.formatearHoraCorta(t.hora),
                t.nombrePasaje,
                CurrencyHelper.formatearCLP(t.valor),
                t.comprobante,
              ]).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(5),
            ),

            pw.SizedBox(height: 20),

            // Footer
            pw.Divider(),
            pw.Text(
              'Generado el ${DateTimeHelper.formatearFecha(DateTime.now().toString())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        ),
      );

      final path = await _guardarPDF(pdf, 'cierre_${cierre.id}');
      _logger.info('Cierre exportado a PDF: $path');

      return path;
    } catch (e, stackTrace) {
      _logger.error('Error al exportar cierre a PDF', e, stackTrace);
      rethrow;
    }
  }

  /// Crea la hoja de resumen en Excel
  void _crearHojaResumen(Sheet sheet, CierreCaja cierre) {
    sheet.appendRow(['RESUMEN DE CIERRE']);
    sheet.appendRow([]);
    sheet.appendRow(['ID:', cierre.id]);
    sheet.appendRow([
      'Fecha Cierre:',
      DateTimeHelper.formatearFecha(cierre.fechaCierre),
    ]);
    sheet.appendRow([
      'Total Ingresos:',
      CurrencyHelper.formatearCLP(cierre.totalIngresos),
    ]);
    sheet.appendRow([
      'Total Transacciones:',
      cierre.totalTransacciones,
    ]);
    sheet.appendRow([
      'Promedio por Transacción:',
      CurrencyHelper.formatearCLP(cierre.promedioTransaccion),
    ]);
    sheet.appendRow(['Dispositivo:', cierre.dispositivoOrigen]);
  }

  /// Crea la hoja de transacciones en Excel
  void _crearHojaTransacciones(Sheet sheet, List<Transaccion> transacciones) {
    // Headers
    sheet.appendRow([
      'ID',
      'Fecha',
      'Hora',
      'Pasaje',
      'Valor',
      'Comprobante',
    ]);

    // Datos
    for (var t in transacciones) {
      sheet.appendRow([
        t.id,
        DateTimeHelper.formatearFechaCorta(t.fecha),
        DateTimeHelper.formatearHoraCorta(t.hora),
        t.nombrePasaje,
        CurrencyHelper.formatearCLP(t.valor),
        t.comprobante,
      ]);
    }
  }

  /// Guarda el archivo Excel y retorna la ruta
  Future<String> _guardarExcel(Excel excel, String nombre) async {
    final directory = await _obtenerDirectorioExports();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/${nombre}_$timestamp.xlsx';

    final file = File(path);
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }

    return path;
  }

  /// Guarda el archivo PDF y retorna la ruta
  Future<String> _guardarPDF(pw.Document pdf, String nombre) async {
    final directory = await _obtenerDirectorioExports();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/${nombre}_$timestamp.pdf';

    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    return path;
  }

  /// Obtiene el directorio para exports
  Future<Directory> _obtenerDirectorioExports() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final exportsDir = Directory('${documentsDir.path}/posbus_exports');

    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    return exportsDir;
  }

  /// Abre un archivo exportado
  Future<void> abrirArchivo(String path) async {
    try {
      await OpenFile.open(path);
    } catch (e, stackTrace) {
      _logger.error('Error al abrir archivo', e, stackTrace);
      rethrow;
    }
  }
}
