# 📱 Pokédex Flutter

Este projeto é uma aplicação móvel desenvolvida em **Flutter** que consome a **PokeAPI** para listar e exibir detalhes dos Pokémon da primeira geração (Kanto).

O projeto foi desenvolvido como parte de um curso de **Desenvolvimento Mobile**, realizado para complementar minha formação em Engenharia de Computação, com foco em adquirir proficiência em Flutter, Dart e integração de APIs REST.

## ✨ Funcionalidades

* **Listagem de Pokémon:** Exibe os 151 Pokémon da região de Kanto.
* **Paginação:** Carregamento sob demanda (10 itens por vez) para performance de UI.
* **Detalhes:** Navegação para uma tela detalhada com sprite, nome, ID e tipos do Pokémon.
* **Tratamento de Erros:** Feedback visual em caso de falha na requisição.

## 🛠️ Tecnologias Utilizadas

* **Linguagem:** Dart
* **Framework:** Flutter
* **API:** [PokeAPI](https://pokeapi.co/)
* **Packages:** `http`

## 🚀 Destaques Técnicos

Um dos focos do projeto foi a otimização de requisições de rede.

Ao invés de realizar chamadas sequenciais para buscar os detalhes de cada item da lista, foi implementado o **paralelismo** usando `Future.wait`. Isso permite que os detalhes dos 10 Pokémon da página sejam baixados simultaneamente, reduzindo drasticamente o tempo de carregamento.

```dart
// Exemplo da lógica implementada no Service
Future<List<Pokemon>> fetchPokemonPage({int limit = 20, int offset = 0}) async {
    final page = await listPokemons(limit: limit, offset: offset);
    final results = page['results'] as List;
    
    // Busca detalhes em paralelo para performance
    final futures = results.map((r) => fetchPokemonDetail(r['url'])).toList();
    return Future.wait(futures);
}
```

## 📂 Estrutura do Projeto
O código segue uma arquitetura modular:

```bash
lib/
├── models/         # Modelos de dados
├── pages/          # Telas da aplicação (HomePage, DetailsPage)
├── services/       # Comunicação com a API (PokeApiService)
└── widgets/        # Componentes de UI
```
## 📦 Como Rodar
1. Clone o repositório:
```bash
git clone https://github.com/allanyvictoria/pokedex-flutter
cd pokedex_flutter 
```
2. Instale as dependências:
```bash
flutter pub get
```
3. Execute o projeto:
```bash
flutter run
```
Desenvolvido por Allany Victória Santos Araújo.
