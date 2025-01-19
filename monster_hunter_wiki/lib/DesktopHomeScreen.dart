import 'package:flutter/material.dart';
import 'AppData.dart';
import 'ListScreen.dart';

class DesktopHomeScreen extends StatefulWidget {
  @override
  _DesktopHomeScreenState createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  final AppData api = AppData();

  late Future<List<String>> futureCategories;
  Future<List<String>>? futureSearchResults;

  // Controlador para la caja de búsqueda
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Cargamos la lista de categorías al iniciar
    futureCategories = api.fetchCategories();
  }

  // Construye la vista de categorías (si no estamos buscando)
  Widget buildCategoriesView() {
    return FutureBuilder<List<String>>(
      future: futureCategories,
      builder: (context, snapshot) {
        // Mientras se cargan las categorías
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Error al cargar
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Sin datos
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay categorías disponibles'));
        }

        // Lista de categorías
        final categories = snapshot.data!;
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200, 60),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(cat.toUpperCase()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListScreen(title: cat),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Construye la vista de resultados de búsqueda
  Widget buildSearchResultsView() {
    return FutureBuilder<List<String>>(
      future: futureSearchResults,
      builder: (context, snapshot) {
        // Mientras se cargan los resultados
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Error al cargar
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Sin resultados
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron resultados'));
        }

        // Lista de archivos/categorías que coincidieron en la búsqueda
        final results = snapshot.data!;
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: results.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200, 60),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(item.toUpperCase()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListScreen(title: item),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Método para gestionar la acción de "Buscar"
  void _onSearch() {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      // Si no hay texto, mostramos las categorías originales
      setState(() {
        isSearching = false;
        futureSearchResults = null;
      });
    } else {
      // Activamos modo búsqueda
      setState(() {
        isSearching = true;
        // Llamamos al método de AppData para obtener resultados
        futureSearchResults = api.fetchSearchResults(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar sencillo y minimalista
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          'Monster Hunter Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            // Barra de búsqueda justo debajo del título
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de texto
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        border: OutlineInputBorder(),
                        isDense: true, // Más compacto
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

            // Contenido variable (resultados búsqueda o categorías)
            Expanded(
              child: isSearching
                  ? buildSearchResultsView()
                  : buildCategoriesView(),
            ),
          ],
        ),
      ),
    );
  }
}
