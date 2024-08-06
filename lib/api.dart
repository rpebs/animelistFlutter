import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/model/anime_stream_detail.dart';
import 'package:myapp/model/ongoing_model.dart';
import 'model/anime_model.dart';

class ApiService {
  final String baseUrl = 'https://kitsu.io/api/edge';

  Future<List<Anime>> fetchAnimes(String sort,
      {int pageNumber = 1, int pageSize = 9}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/anime?sort=$sort&page[number]=$pageNumber&page[size]=$pageSize'));
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

  Future<List<Anime>> searchAnimes(String query,
      {int pageNumber = 1, int pageSize = 9}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/anime?filter[text]=$query&page[number]=$pageNumber&page[size]=$pageSize'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data.map<Anime>((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search animes');
    }
  }

  static const String otakuDesuBase = 'https://nya-otakudesu.vercel.app/api/v1';

  Future<List<Ongoing>> fetchOngoing(int page) async {
    final response = await http.get(Uri.parse('$otakuDesuBase/ongoing/$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['ongoing'];
      return data.map<Ongoing>((json) => Ongoing.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ongoing data');
    }
  }

  Future<AnimeDetailModel> fetchAnimeDetail(String endpoint) async {
    final response =
        await http.get(Uri.parse('$otakuDesuBase/detail/$endpoint'));

    if (response.statusCode == 200) {
      try {
        return AnimeDetailModel.fromJson(json.decode(response.body));
      } catch (e) {
        print("Error parsing JSON: $e");
        throw Exception("Failed to parse JSON");
      }
    } else {
      throw Exception('Failed to load anime detail');
    }
  }
}
