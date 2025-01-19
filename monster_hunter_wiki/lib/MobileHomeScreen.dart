// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'AppData.dart';
import 'ListScreen.dart';

class MobileHomeScreen extends StatefulWidget {
  @override
  _MobileHomeScreenState createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  final AppData api = AppData();

  late Future<List<String>> futureCategories;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargamos las categorías al inicio
    futureCategories = api.fetchCategories();
  }

  // Método para manejar la búsqueda
  void _onSearch() async {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      try {
        final results = await api.fetchSearchResults(query);

        // Navegamos a ListScreen con los resultados de búsqueda
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListScreen(
              title: query,
              searchResults: results,
            ),
          ),
        );
      } catch (e) {
        // Mostramos un mensaje si ocurre algún error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al buscar: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingrese un término de búsqueda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Hunter Categories'),
      ),
      body: Column(
        children: [
          // Barra de búsqueda en la parte superior
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Campo de texto para la búsqueda
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      border: OutlineInputBorder(),
                      isDense: true, // Hace que el campo sea más compacto
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                SizedBox(width: 8),
                // Botón de búsqueda
                TextButton(
                  onPressed: _onSearch,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Buscar'),
                ),
              ],
            ),
          ),
          // Lista de categorías debajo de la barra de búsqueda
          Expanded(
            child: FutureBuilder<List<String>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay categorías disponibles'));
                }

                // Muestra las categorías en una lista
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
          ),
        ],
      ),
    );
  }
}
