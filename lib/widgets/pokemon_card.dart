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

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;
  const PokemonCard({required this.pokemon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.first.toLowerCase();
    final bgColor = getTypeColor(primaryType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'poke-${pokemon.id}',
              child: Image.network(
                pokemon.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Wrap(
                      spacing: 4,
                      children: pokemon.types
                          .map((t) => Chip(
                                label: Text(t.toUpperCase()),
                                backgroundColor: Colors.white.withOpacity(0.7),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
