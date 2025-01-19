import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // Para estructuras de widgets adicionales

void main() {
  runApp(MonsterHunterApp());
}

class MonsterHunterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monster Hunter App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ResponsiveHomeScreen(),
    );
  }
}

class ResponsiveHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width <= 600) {
      return MobileHomeScreen();
    } else {
      return DesktopHomeScreen();
    }
  }
}

class MobileHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Hunter Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListScreen('Monstruos', monsters)),
                );
              },
              child: Text('Monstruos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListScreen('Armas', weapons)),
                );
              },
              child: Text('Armas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListScreen('Armaduras', armors)),
                );
              },
              child: Text('Armaduras'),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopHomeScreen extends StatefulWidget {
  @override
  _DesktopHomeScreenState createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Hunter Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: Text('Selecciona una categoría'),
              value: selectedCategory,
              items: [
                DropdownMenuItem(value: 'Monstruos', child: Text('Monstruos')),
                DropdownMenuItem(value: 'Armas', child: Text('Armas')),
                DropdownMenuItem(value: 'Armaduras', child: Text('Armaduras')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
                if (value == 'Monstruos') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ListScreen('Monstruos', monsters)),
                  );
                } else if (value == 'Armas') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListScreen('Armas', weapons)),
                  );
                } else if (value == 'Armaduras') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListScreen('Armaduras', armors)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  ListScreen(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['nombre']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(items[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  DetailScreen(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['nombre']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(item['descripcion']),
            SizedBox(height: 16),
            if (item.containsKey('resistencias')) ...[
              Text('Resistencias:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...item['resistencias']
                  .entries
                  .map((entry) => Text('${entry.key}: ${entry.value}'))
                  .toList(),
            ],
            if (item.containsKey('tipos_dano')) ...[
              Text('Tipos de Daño:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item['tipos_dano'].join(', ')),
            ],
          ],
        ),
      ),
    );
  }
}

// Example JSON data
final monsters = [
  {
    "nombre": "Rathalos",
    "descripcion":
        "El Rey de los Cielos, un wyvern volador que expulsa fuego y ataca con ferocidad desde el aire.",
    "imagen": "rathalos.jpg"
  },
  {
    "nombre": "Anjanath",
    "descripcion":
        "Un wyvern brutish que asemeja a un dinosaurio, conocido por sus ataques de fuego y gran agresividad.",
    "imagen": "anjanath.jpg"
  }
];

final weapons = [
  {
    "nombre": "Espada Larga",
    "descripcion":
        "Una elegante arma de filo largo que permite realizar ataques rápidos y combinaciones fluidas.",
    "tipos_dano": ["Corte"],
    "imagen": "espada_larga.jpg"
  },
  {
    "nombre": "Gran Espada",
    "descripcion":
        "Una arma pesada con un gran alcance que permite realizar ataques devastadores, aunque lentos.",
    "tipos_dano": ["Corte"],
    "imagen": "gran_espada.jpg"
  }
];

final armors = [
  {
    "nombre": "Armadura Rathalos",
    "descripcion":
        "Una armadura basada en el Rathalos, que ofrece alta resistencia al fuego y habilidades que mejoran los ataques elementales.",
    "resistencias": {
      "fuego": 3,
      "agua": -2,
      "trueno": 1,
      "hielo": -3,
      "dragón": 0
    },
    "imagen": "armadura_rathalos.jpg"
  },
  {
    "nombre": "Armadura Nergigante",
    "descripcion":
        "Una armadura poderosa con habilidades que aumentan el daño y la regeneración al atacar.",
    "resistencias": {
      "fuego": 1,
      "agua": 1,
      "trueno": -2,
      "hielo": -1,
      "dragón": 3
    },
    "imagen": "armadura_nergigante.jpg"
  }
];
