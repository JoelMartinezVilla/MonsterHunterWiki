// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'AppData.dart';
import 'ListScreen.dart';

// Versión para pantallas móviles
class MobileHomeScreen extends StatelessWidget {
  final AppData api = AppData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Hunter Categories'),
      ),
      body: FutureBuilder<List<String>>(
        future: api.fetchCategories(),
        builder: (context, snapshot) {
          // Mientras cargan las categorías
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Si hubo error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Si viene vacío
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay categorías disponibles'));
          }

          // Tenemos categorías
          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListScreen(title: category),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
