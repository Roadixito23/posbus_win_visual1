import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/configuracion_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/api_service.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conexión a la API REST
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conexión con el Servidor',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.cloud, size: 32),
                      title: const Text('URL del Servidor API'),
                      subtitle: Text(
                        ApiService.baseUrl,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<ConfiguracionProvider>(
                      builder: (context, configProvider, child) {
                        return ListTile(
                          leading: Icon(
                            configProvider.isConnected
                              ? Icons.check_circle
                              : Icons.error_outline,
                            color: configProvider.isConnected
                              ? Colors.green
                              : Colors.red,
                            size: 32,
                          ),
                          title: Text(
                            configProvider.isConnected
                              ? 'Conectado al servidor'
                              : 'Sin conexión al servidor',
                          ),
                          subtitle: Text(
                            configProvider.isConnected
                              ? 'La API está respondiendo correctamente'
                              : 'No se pudo conectar con la API',
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _isChecking ? null : _verificarConexion,
                        icon: _isChecking
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.wifi_find),
                        label: Text(_isChecking
                          ? 'Verificando...'
                          : 'Verificar Conexión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Preferencias de Aplicación
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferencias',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return SwitchListTile(
                          title: const Text('Tema Oscuro'),
                          subtitle: const Text('Activa el modo oscuro'),
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.setTheme(value);
                            Provider.of<ConfiguracionProvider>(context, listen: false)
                                .actualizarTema(value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Información de la App
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Versión'),
                      trailing: Text('1.0.0'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.code),
                      title: Text('Desarrollado para'),
                      trailing: Text('POSBUS Suray'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verificarConexion() async {
    setState(() {
      _isChecking = true;
    });

    try {
      final configProvider = Provider.of<ConfiguracionProvider>(context, listen: false);
      final conectado = await configProvider.verificarConexionAPI();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            conectado
              ? 'Conexión establecida correctamente'
              : 'No se pudo conectar con el servidor',
          ),
          backgroundColor: conectado ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }
}
