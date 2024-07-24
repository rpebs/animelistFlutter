import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/anime_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://kitsu.io/api/edge/anime?sort=-favoritesCount';

  Future<List<Anime>> fetchAnimes() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load anime');
    }
  }
}
