import 'package:flutter/material.dart';
import '../models/pokemon.dart';

Color getTypeColor(String type) {
  switch (type) {
    case 'fire': return Colors.orange;
    case 'water': return Colors.blue;
    case 'grass': return Colors.green;
    case 'bug': return Colors.lightGreen;
    case 'poison': return Colors.purple;
    case 'electric': return Colors.yellow;
    case 'ground': return Colors.brown;
    case 'psychic': return Colors.pink;
    case 'rock': return Colors.grey;
    case 'ice': return Colors.cyan;
    case 'dragon': return Colors.indigo;
    case 'ghost': return Colors.deepPurple;
    case 'dark': return Colors.black87;
    case 'fairy': return Colors.pinkAccent;
    default: return Colors.red.shade200;
  }
}

class DetailsPage extends StatelessWidget {
  final Pokemon pokemon;
  const DetailsPage({required this.pokemon, super.key});

  static const int _statMax = 255;

  @override
  Widget build(BuildContext context) {
    final typeColor = getTypeColor(pokemon.types.first.toLowerCase());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: typeColor,
        title: Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner com gradiente + Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    typeColor,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Hero(
                tag: 'poke-${pokemon.id}',
                child: Image.network(
                  pokemon.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ID e tipos
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: pokemon.types.map(
                (t) => Chip(
                  label: Text(
                    t.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: typeColor.withOpacity(0.25),
                ),
              ).toList(),
            ),

            const SizedBox(height: 20),

            // Height & Weight
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Altura'),
                      Text('${pokemon.height / 10} m'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Peso'),
                      Text('${pokemon.weight / 10} kg'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Status Base',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Stats com barras estilizadas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: pokemon.stats.entries.map(
                  (e) {
                    final key = e.key.toUpperCase();
                    final value = e.value;
                    final normalized = (value / _statMax).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  key,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(value.toString()),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: normalized,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation(typeColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
