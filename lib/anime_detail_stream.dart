import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/api.dart';
import 'package:myapp/model/anime_stream_detail.dart';
import 'model/anime_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String endpoint;

  AnimeDetailScreen({required this.endpoint});

  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  late Future<AnimeDetailModel> _animeDetail;

  @override
  void initState() {
    super.initState();
    _animeDetail = ApiService().fetchAnimeDetail(widget.endpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Detail'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<AnimeDetailModel>(
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
              final episodeList = snapshot.data!.episodeList;
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
                          image: NetworkImage(anime.animeDetail.thumb),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      anime.animeDetail.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 18),
                    const Text('Synopsis:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      anime.animeDetail.sinopsis != null &&
                              anime.animeDetail.sinopsis!.isNotEmpty
                          ? anime.animeDetail.sinopsis!.first
                          : 'No description available',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: episodeList.length,
                      itemBuilder: (context, index) {
                        final episode = episodeList[index];
                        return ListTile(
                          onTap: () async {
                            final link = episodeList[index]
                                .episodeEndpoint; // Akses youtubeId dengan benar
                            if (link != null && link.isNotEmpty) {
                              final url =
                                  'https://otakudesu.cloud/episode/${link}'; // Bangun URL dengan benar
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
                          title: Text(episode.episodeTitle),
                          subtitle: Text(episode.episodeDate),
                        );
                      },
                    ),
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
