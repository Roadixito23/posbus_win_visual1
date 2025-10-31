import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cierres_provider.dart';
import 'providers/configuracion_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/cierres/cierres_list_screen.dart';
import 'screens/cierres/detalle_cierre_screen.dart';
import 'screens/estadisticas/estadisticas_screen.dart';
import 'screens/configuracion/configuracion_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'POSBUS Suray - Visualizador',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/cierres': (context) => const CierresListScreen(),
            '/detalle': (context) => const DetalleCierreScreen(),
            '/estadisticas': (context) => const EstadisticasScreen(),
            '/configuracion': (context) => const ConfiguracionScreen(),
          },
        );
      },
    );
  }
}
