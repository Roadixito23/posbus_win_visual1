import 'package:flutter/material.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Estadísticas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Esta funcionalidad estará disponible próximamente'),
          ],
        ),
      ),
    );
  }
}
