import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cierres_provider.dart';
import '../../core/utils/currency_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
    final provider = Provider.of<CierresProvider>(context, listen: false);
    await provider.cargarCierres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - POSBUS Suray'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarDatos,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer<CierresProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _cargarDatos,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final cierres = provider.cierres;
          final totalIngresos = cierres.fold<double>(
            0.0,
            (sum, cierre) => sum + cierre.totalIngresos,
          );
          final totalTransacciones = cierres.fold<int>(
            0,
            (sum, cierre) => sum + cierre.totalTransacciones,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Métricas principales
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Total Ingresos',
                        CurrencyHelper.formatearCLP(totalIngresos),
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Número de Cierres',
                        '${cierres.length}',
                        Icons.receipt_long,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Total Transacciones',
                        '$totalTransacciones',
                        Icons.shopping_cart,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Lista de cierres recientes
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cierres Recientes',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/cierres');
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Ver Todos'),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (cierres.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('No hay cierres disponibles'),
                            ),
                          )
                        else
                          ...cierres.take(5).map((cierre) => ListTile(
                                leading: CircleAvatar(
                                  child: Text('${cierre.id}'),
                                ),
                                title: Text('Cierre #${cierre.id}'),
                                subtitle: Text(cierre.fechaCierre),
                                trailing: Text(
                                  CurrencyHelper.formatearCLP(cierre.totalIngresos),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () {
                                  provider.seleccionarCierre(cierre);
                                  Navigator.pushNamed(context, '/detalle');
                                },
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

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
