// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';
import '../widgets/pokemon_card.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PokeApiService api = PokeApiService();
  final ScrollController _scrollController = ScrollController();
  final List<Pokemon> _items = [];
  bool _loading = false;
  bool _hasMore = true;
  int _offset = 0;
  static const int _limit = 20;
  String _query = '';
  Pokemon? _searchResult;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_loading && _hasMore && _query.isEmpty) {
        _loadNextPage();
      }
    });
  }

  Future<void> _loadNextPage() async {
    setState(() { _loading = true; });
    try {
      final page = await api.fetchPokemonPage(limit: _limit, offset: _offset);
      if (page.isEmpty) {
        _hasMore = false;
      } else {
        _items.addAll(page);
        _offset += _limit;
      }
    } catch (e) {
      // opcional: mostrar snack
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar: $e')));
      _hasMore = false;
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _items.clear();
      _offset = 0;
      _hasMore = true;
      _searchResult = null;
      _searchError = null;
      _query = '';
    });
    await _loadNextPage();
  }

  Future<void> _doSearch(String q) async {
    q = q.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() { _query = ''; _searchResult = null; _searchError = null; });
      return;
    }
    setState(() { _query = q; _searchResult = null; _searchError = null; _loading = true; });
    try {
      final p = await api.fetchPokemonDetail(q);
      setState(() { _searchResult = p; });
    } catch (e) {
      setState(() { _searchError = 'Pokémon não encontrado'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildList() {
    final list = _query.isEmpty ? _items : (_searchResult != null ? [_searchResult!] : []);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          if (index < list.length) {
            final p = list[index];
            return PokemonCard(
              pokemon: p,
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, animation, __) =>
                        FadeTransition(opacity: animation, child: DetailsPage(pokemon: p)),
                  ),
                );
              },


            );
          } else {
            // loader/footer
            if (_loading) return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
            if (!_hasMore && _query.isEmpty) return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text('Fim da lista')),
            );
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex — Fase 2'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: _doSearch,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome ou id (ex: pikachu ou 25)',
                      suffixIcon: _query.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: (){ _doSearch(''); }) : null,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.search), onPressed: (){ /* enter no textfield já busca */ }),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_searchError != null) Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_searchError!, style: const TextStyle(color: Colors.red)),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }
}
