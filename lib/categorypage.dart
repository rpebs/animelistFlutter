import 'package:flutter/material.dart';
import 'api.dart';
import 'model/anime_model.dart';
import 'widgets/anime_card.dart'; // Pastikan Anda memiliki AnimeCard

class AnimeCategoryPage extends StatefulWidget {
  final String categoryName;

  const AnimeCategoryPage({super.key, required this.categoryName});

  @override
  _AnimeCategoryPageState createState() => _AnimeCategoryPageState();
}

class _AnimeCategoryPageState extends State<AnimeCategoryPage> {
  final ApiService apiService = ApiService();
  late ScrollController _scrollController;
  List<Anime> _animes = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

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
      final animes = await apiService.fetchAnimesByCategory(
        widget.categoryName.toLowerCase(),
        pageNumber: _currentPage,
        pageSize: 9,
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Anime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _isLoading && _animes.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Wrap(
                      spacing: 10, // Spasi horizontal antara item
                      runSpacing: 20, // Spasi vertikal antara item
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
    );
  }
}
