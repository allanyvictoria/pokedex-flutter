// lib/services/poke_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  static const String _base = 'https://pokeapi.co/api/v2/pokemon';

  // Lista paginada: retorna lista de maps {name, url} e next/previous se precisar
  Future<Map<String, dynamic>> listPokemons({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse('$_base?limit=$limit&offset=$offset');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Erro ao listar pokemons: ${res.statusCode}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // Pega detalhe por url ou nome/id
  Future<Pokemon> fetchPokemonDetail(String urlOrName) async {
    final uri = Uri.parse(urlOrName.startsWith('http') ? urlOrName : '$_base/$urlOrName');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Erro ao buscar detalhe: ${res.statusCode}');
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return Pokemon.fromJson(json);
  }

  // Função utilitária: busca a página (lista de Pokemons com detalhe carregado)
  Future<List<Pokemon>> fetchPokemonPage({int limit = 20, int offset = 0}) async {
    final page = await listPokemons(limit: limit, offset: offset);
    final results = page['results'] as List;
    // buscar todos os detalhes em paralelo
    final futures = results.map((r) => fetchPokemonDetail(r['url'] as String)).toList();
    return Future.wait(futures);
  }
}
