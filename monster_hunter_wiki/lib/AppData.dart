import 'dart:convert';
import 'package:http/http.dart' as http;

class AppData {
  // Ajusta la URL base según donde corra tu servidor
  // Si lo corres en local, pondrías algo como:
  final String baseUrl = 'http://127.0.0.1:3000/api';

  // Obtiene la lista de categorías (los nombres de los ficheros JSON sin extensión).
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      // Decodificar el JSON (que debe ser una lista de strings)
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Error al obtener categorías');
    }
  }

  // Obtiene el contenido completo de un fichero JSON (por ejemplo 'monsters.json')
  Future<List<dynamic>> fetchItems(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/$category'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al obtener items de $category');
    }
  }

  Future<List<String>> fetchSearchResults(String query) async {
    final url = Uri.parse('http://localhost:3000/api/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // El servidor devuelve una lista de strings
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Error al obtener resultados de búsqueda');
    }
  }
}
