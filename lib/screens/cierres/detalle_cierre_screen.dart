import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cierres_provider.dart';
import '../../services/export_service.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/utils/date_time_helper.dart';

class DetalleCierreScreen extends StatelessWidget {
  const DetalleCierreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Cierre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportarExcel(context),
            tooltip: 'Exportar a Excel',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportarPDF(context),
            tooltip: 'Exportar a PDF',
          ),
        ],
      ),
      body: Consumer<CierresProvider>(
        builder: (context, provider, child) {
          final cierre = provider.cierreSeleccionado;

          if (cierre == null) {
            return const Center(
              child: Text('No hay cierre seleccionado'),
            );
          }

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final transacciones = provider.transaccionesCierreSeleccionado;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del cierre
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cierre #${cierre.id}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Fecha de Cierre',
                          DateTimeHelper.formatearFecha(cierre.fechaCierre),
                        ),
                        _buildInfoRow(
                          'Total Ingresos',
                          CurrencyHelper.formatearCLP(cierre.totalIngresos),
                        ),
                        _buildInfoRow(
                          'Total Transacciones',
                          '${cierre.totalTransacciones}',
                        ),
                        _buildInfoRow(
                          'Promedio por Transacción',
                          CurrencyHelper.formatearCLP(cierre.promedioTransaccion),
                        ),
                        _buildInfoRow(
                          'Dispositivo Origen',
                          cierre.dispositivoOrigen,
                        ),
                        if (cierre.sincronizadoEn != null)
                          _buildInfoRow(
                            'Sincronizado En',
                            DateTimeHelper.formatearFecha(cierre.sincronizadoEn.toString()),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Lista de transacciones
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transacciones (${transacciones.length})',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        if (transacciones.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text('No hay transacciones'),
                            ),
                          )
                        else
                          ...transacciones.map((t) => ListTile(
                                leading: Icon(
                                  Icons.receipt,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(t.nombrePasaje),
                                subtitle: Text(
                                  '${DateTimeHelper.formatearHoraCorta(t.hora)} - ${t.comprobante}',
                                ),
                                trailing: Text(
                                  CurrencyHelper.formatearCLP(t.valor),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _exportarExcel(BuildContext context) async {
    try {
      final provider = Provider.of<CierresProvider>(context, listen: false);
      final cierre = provider.cierreSeleccionado;
      final transacciones = provider.transaccionesCierreSeleccionado;

      if (cierre == null) return;

      final exportService = ExportService();
      final path = await exportService.exportarCierreExcel(cierre, transacciones);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exportado a: $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    }
  }

  Future<void> _exportarPDF(BuildContext context) async {
    try {
      final provider = Provider.of<CierresProvider>(context, listen: false);
      final cierre = provider.cierreSeleccionado;
      final transacciones = provider.transaccionesCierreSeleccionado;

      if (cierre == null) return;

      final exportService = ExportService();
      final path = await exportService.exportarCierrePDF(cierre, transacciones);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exportado a: $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    }
  }
}
