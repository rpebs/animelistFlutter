import 'package:flutter/material.dart';
import 'api.dart';
import 'categorypage.dart';
import 'model/anime_model.dart';
import 'widgets/anime_card.dart'; // Import AnimeCard

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  String selectedCategory = 'adventure';
  Future<List<Anime>>? adventureAnimes;

  @override
  void initState() {
    super.initState();
    adventureAnimes = apiService.fetchAnimesByCategory(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Hi, Ramadhany ! 👋🏻',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.search, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.notifications, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            'https://as1.ftcdn.net/v2/jpg/03/16/68/46/1000_F_316684629_b42XaBaU7Z3yqYme0KGP1hYRHybR9JYb.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Trending Anime',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 250,
                  child: FutureBuilder<List<Anime>>(
                    future: apiService.fetchAnimes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No anime found'));
                      } else {
                        final animes = snapshot.data!
                            .take(8)
                            .toList(); // Ambil hanya 8 teratas
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: animes.map((anime) {
                              return AnimeCard(
                                  imageUrl: anime.posterImage,
                                  title: anime.title,
                                  episode: anime.episodeCount.toString(),
                                  rating: anime.averageRating != null
                                      ? double.parse(anime.averageRating!)
                                      : 0);
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Adventure',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnimeCategoryPage(categoryName: 'Adventure'),
                          ),
                        );
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 12, 0, 89)),
                      ),
                    ),
                  ],
                ),
                Container(
                  // Atur tinggi tetap jika ingin memiliki ruang khusus untuk scroll horizontal
                  child: FutureBuilder<List<Anime>>(
                    future: adventureAnimes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No anime found'));
                      } else {
                        final animes = snapshot.data!
                            .take(8)
                            .toList(); // Ambil hanya 8 teratas
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: animes.map((anime) {
                              return AnimeCard(
                                  imageUrl: anime.posterImage,
                                  title: anime.title,
                                  episode: anime.episodeCount.toString(),
                                  rating: anime.averageRating != null
                                      ? double.parse(anime.averageRating!)
                                      : 0);
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        backgroundColor: Color.fromARGB(255, 23, 0, 124),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.trending_up,
              color: Colors.white,
            ),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            label: 'Favorites',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle tab selection
        },
      ),
    );
  }
}
