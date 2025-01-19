// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'AppData.dart';
import 'DetailScreen.dart';

class ListScreen extends StatefulWidget {
  final String title;
  const ListScreen({Key? key, required this.title}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final AppData api = AppData();
  late Future<List<dynamic>> futureItems;

  @override
  void initState() {
    super.initState();
    // Llamamos a la API pasando el nombre de la categoría (ej. "monsters")
    futureItems = api.fetchItems(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureItems,
        builder: (context, snapshot) {
          // Mientras está cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Sin datos
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos en esta categoría'));
          }

          // Datos leídos
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final nombre = item['nombre'] ?? 'Sin nombre';

              return ListTile(
                title: Text(nombre),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(item: item),
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
