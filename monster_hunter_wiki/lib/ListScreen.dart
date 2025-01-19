import 'package:flutter/material.dart';
import 'AppData.dart';
import 'DetailScreen.dart';

class ListScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>>? searchResults;

  const ListScreen({
    Key? key,
    required this.title,
    this.searchResults,
  }) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final AppData api = AppData();
  late Future<List<Map<String, dynamic>>> futureItems;

  @override
  void initState() {
    super.initState();

    if (widget.searchResults != null) {
      futureItems = Future.value(widget.searchResults);
    } else {
      futureItems = api.fetchItems(widget.title).then(
            (value) => value.cast<Map<String, dynamic>>(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 3, 126, 50),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No se encontraron resultados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final item = items[index];
              final nombre = item['nombre'] ?? 'Sin nombre';
              final descripcion = item['descripcion'] ?? 'Sin descripción';
              final imagen = item['imagen']; // Nombre de la imagen

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imagen != null
                        ? Image.network(
                            api.fetchImage(imagen),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 50);
                            },
                          )
                        : Icon(Icons.image_not_supported, size: 50),
                  ),
                  title: Text(
                    nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(item: item),
                      ),
                    );
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
