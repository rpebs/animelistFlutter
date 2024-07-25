import 'package:flutter/material.dart';
import 'api.dart';
import 'model/anime_model.dart';
import 'widgets/anime_card.dart'; // Pastikan Anda memiliki AnimeCard
import 'anime_detail.dart'; // Import halaman detail

class ListAnime extends StatefulWidget {
  const ListAnime({super.key});

  @override
  _ListAnimeState createState() => _ListAnimeState();
}

class _ListAnimeState extends State<ListAnime> {
  final ApiService apiService = ApiService();
  late ScrollController _scrollController;
  List<Anime> _animes = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchAnimes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchAnimes();
    }
  }

  Future<void> _fetchAnimes() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Anime> animes;
      if (_searchQuery.isEmpty) {
        animes = await apiService.fetchAnimes('-favoritesCount',
            pageNumber: _currentPage, pageSize: 9);
      } else {
        animes = await apiService.searchAnimes(_searchQuery,
            pageNumber: _currentPage, pageSize: 9);
      }

      setState(() {
        _currentPage++;
        _animes.addAll(animes);
        _hasMore = animes.length == 9;
      });
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshAnimes() async {
    setState(() {
      _animes.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchAnimes();
  }

  void _searchAnime(String query) {
    setState(() {
      _animes.clear();
      _currentPage = 1;
      _hasMore = true;
      _searchQuery = query;
    });
    _fetchAnimes();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear(); // Clear the text field
      _animes.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    _fetchAnimes();
  }

  void _onAnimeTap(String animeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimeDetailPage(animeId: animeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Anime'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Stack(
              children: [
                TextField(
                  controller: _searchController, // Set the controller
                  decoration: InputDecoration(
                    hintText: 'Search Anime...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onSubmitted: (query) {
                    _searchAnime(query);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _isLoading && _animes.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _refreshAnimes,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10, // Spasi horizontal antara item
                        runSpacing: 10, // Spasi vertikal antara item
                        children: _animes.map((anime) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) /
                                3, // Lebar kolom
                            child: AnimeCard(
                              imageUrl: anime.posterImage,
                              title: anime.title,
                              episode: anime.episodeCount.toString(),
                              rating: anime.averageRating != null
                                  ? double.parse(anime.averageRating!)
                                  : 0,
                              onTap: () => _onAnimeTap(
                                  anime.id), // Tambahkan callback onTap
                            ),
                          );
                        }).toList(),
                      ),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
