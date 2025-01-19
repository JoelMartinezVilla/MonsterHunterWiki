// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nombre = item['nombre'] ?? '';
    final descripcion = item['descripcion'] ?? '';
    final resistencias = item['resistencias'];
    final tiposDano = item['tipos_dano'];
    final imagen = item['imagen']; // Ej: "rathalos.jpg"

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagen != null)
              Center(
                child: Image.network(
                  // Ajusta esta URL a la de tu servidor
                  'http://127.0.0.1:3000/images/$imagen',
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error cargando imagen');
                  },
                ),
              ),
            SizedBox(height: 16),
            Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(descripcion),
            SizedBox(height: 16),
            if (resistencias != null && resistencias is Map)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resistencias:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...resistencias.entries.map((entry) {
                    return Text('${entry.key}: ${entry.value}');
                  }),
                ],
              ),
            SizedBox(height: 16),
            if (tiposDano != null && tiposDano is List)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipos de Daño:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(tiposDano.join(', ')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
