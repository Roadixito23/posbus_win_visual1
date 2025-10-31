import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cierres_provider.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/utils/date_time_helper.dart';

class CierresListScreen extends StatefulWidget {
  const CierresListScreen({super.key});

  @override
  State<CierresListScreen> createState() => _CierresListScreenState();
}

class _CierresListScreenState extends State<CierresListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CierresProvider>(context, listen: false).cargarCierres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cierres de Caja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CierresProvider>(context, listen: false).refresh();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer<CierresProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final cierres = provider.cierres;

          if (cierres.isEmpty) {
            return const Center(
              child: Text('No hay cierres disponibles'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cierres.length,
            itemBuilder: (context, index) {
              final cierre = cierres[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${cierre.id}'),
                  ),
                  title: Text('Cierre #${cierre.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateTimeHelper.formatearFecha(cierre.fechaCierre)),
                      Text('${cierre.totalTransacciones} transacciones'),
                      Text('Dispositivo: ${cierre.dispositivoOrigen}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyHelper.formatearCLP(cierre.totalIngresos),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    provider.seleccionarCierre(cierre);
                    Navigator.pushNamed(context, '/detalle');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
