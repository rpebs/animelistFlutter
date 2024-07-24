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
        padding: const EdgeInsets.only(left: 5),
        child: Center(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Jumlah kolom dalam grid
                  childAspectRatio:
                      0.5, // Sesuaikan rasio aspek (lebar / tinggi)
                  crossAxisSpacing: 10, // Spasi horizontal antara item
                  mainAxisSpacing: 10, // Spasi vertikal antara item
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _animes.length) {
                      // Item terakhir adalah indikator pemuatan jika ada lebih banyak data
                      return Center(
                          // child: Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: const CircularProgressIndicator(),
                          // ),
                          );
                    }
                    final anime = _animes[index];
                    return AnimeCard(
                      imageUrl: anime.posterImage,
                      title: anime.title,
                      episode: anime.episodeCount.toString(),
                      rating: anime.averageRating != null
                          ? double.parse(anime.averageRating!)
                          : 0,
                    );
                  },
                  childCount: _animes.length + (_hasMore ? 1 : 0),
                ),
              ),
              if (_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: const CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
