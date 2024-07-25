import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'model/anime_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailPage extends StatefulWidget {
  final String animeId;

  const AnimeDetailPage({super.key, required this.animeId});

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  late Future<Anime> _animeDetail;

  @override
  void initState() {
    super.initState();
    _animeDetail = _fetchAnimeDetail();
  }

  Future<Anime> _fetchAnimeDetail() async {
    final response = await http
        .get(Uri.parse('https://kitsu.io/api/edge/anime/${widget.animeId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Anime.fromJson(data);
    } else {
      throw Exception('Failed to load anime details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Detail'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Anime>(
          future: _animeDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final anime = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(anime.posterImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      anime.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingBarIndicator(
                          unratedColor: Colors.grey,
                          rating: anime.averageRating != null
                              ? double.parse(anime.averageRating!) / 20
                              : 0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        const Spacer(),
                        Text('Episodes: ${anime.episodeCount ?? 'N/A'}'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text('Synopsis:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(anime.synopsis ?? 'No description available',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          backgroundColor: const Color.fromARGB(255, 0, 2, 125),
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        final youtubeId =
                            anime.youtubeId; // Akses youtubeId dengan benar
                        if (youtubeId != null && youtubeId.isNotEmpty) {
                          final url =
                              'https://www.youtube.com/watch?v=$youtubeId'; // Bangun URL dengan benar
                          if (!await launchUrl(Uri.parse(url))) {
                            throw Exception('Could not launch $url');
                          }
                        } else {
                          // Tangani kasus di mana youtubeId tidak tersedia
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('No trailer available')),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow),
                          SizedBox(width: 10),
                          Text('Watch Trailer',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
