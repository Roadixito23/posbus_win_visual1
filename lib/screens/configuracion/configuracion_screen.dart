import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/configuracion_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/database_service.dart';
import '../../core/utils/validators.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _databaseController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarConfiguracion();
    });
  }

  void _cargarConfiguracion() {
    final config = Provider.of<ConfiguracionProvider>(context, listen: false).configuracion;
    _hostController.text = config.dbHost;
    _portController.text = config.dbPort.toString();
    _databaseController.text = config.dbName;
    _usernameController.text = config.dbUsername;
    _passwordController.text = config.dbPassword;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _databaseController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            // Configuración de Base de Datos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conexión a Base de Datos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      TextFormField(
                        controller: _hostController,
                        decoration: const InputDecoration(
                          labelText: 'Host',
                          hintText: 'api.danteaguerorodriguez.work',
                        ),
                        validator: Validators.host,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _portController,
                        decoration: const InputDecoration(
                          labelText: 'Puerto',
                          hintText: '5432',
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.puerto,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _databaseController,
                        decoration: const InputDecoration(
                          labelText: 'Base de Datos',
                          hintText: 'posbus_suray',
                        ),
                        validator: (v) => Validators.requerido(v, mensaje: 'La base de datos es requerida'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          hintText: 'posbus_user',
                        ),
                        validator: (v) => Validators.requerido(v, mensaje: 'El usuario es requerido'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _probarConexion,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Probar Conexión'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _guardarConfiguracion,
                            icon: const Icon(Icons.save),
                            label: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ],
                  ),
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

  Future<void> _probarConexion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    try {
      final dbService = DatabaseService();

      // Mostrar indicador de carga
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      await dbService.conectar(
        host: _hostController.text,
        port: int.parse(_portController.text),
        database: _databaseController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      final conectado = await dbService.probarConexion();

      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
      }

      if (conectado) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('✓ Conexión exitosa'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('✗ No se pudo establecer la conexión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _guardarConfiguracion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final provider = Provider.of<ConfiguracionProvider>(context, listen: false);

      await provider.actualizarConfiguracionDB(
        host: _hostController.text,
        port: int.parse(_portController.text),
        database: _databaseController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Configuración guardada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
