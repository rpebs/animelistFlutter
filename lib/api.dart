import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/anime_model.dart';

class ApiService {
  final String baseUrl = 'https://kitsu.io/api/edge';

  Future<List<Anime>> fetchAnimes(String sort) async {
    final response = await http.get(Uri.parse('$baseUrl/anime?sort=${sort}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> animeList = data['data'];
      return animeList.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load anime');
    }
  }

  Future<List<Anime>> fetchAnimesByCategory(String category,
      {int pageNumber = 1, int pageSize = 9}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/anime?filter[categories]=$category&page[number]=$pageNumber&page[size]=$pageSize'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data.map<Anime>((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load animes');
    }
  }
}
