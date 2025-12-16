// lib/models/pokemon.dart
class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final int height;
  final int weight;
  final Map<String,int> stats; // ex: {'hp': 45, 'attack': 49, ...}

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final statsMap = <String,int>{};
    for (var s in (json['stats'] as List)) {
      final statName = (s['stat']['name'] as String);
      final baseStat = (s['base_stat'] as num).toInt();
      statsMap[statName] = baseStat;
    }

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      types: types,
      imageUrl: (json['sprites']['other']?['official-artwork']?['front_default'] ??
                json['sprites']['front_default'] ??
                '') as String,
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      stats: statsMap,
    );
  }
}
