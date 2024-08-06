class AnimeDetailModel {
  final bool status;
  final String message;
  final AnimeDetail animeDetail;
  final List<Episode> episodeList;

  AnimeDetailModel({
    required this.status,
    required this.message,
    required this.animeDetail,
    required this.episodeList,
  });

  factory AnimeDetailModel.fromJson(Map<String, dynamic> json) {
    var episodeListJson = json['episode_list'] as List;
    List<Episode> episodeList =
        episodeListJson.map((i) => Episode.fromJson(i)).toList();

    return AnimeDetailModel(
      status: json['status'],
      message: json['message'],
      animeDetail: AnimeDetail.fromJson(json['anime_detail']),
      episodeList: episodeList,
    );
  }
}

class AnimeDetail {
  final String thumb;
  final List<String>? sinopsis;
  final List<String>? detail;
  final String title;

  AnimeDetail({
    required this.thumb,
    this.sinopsis,
    this.detail,
    required this.title,
  });

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    return AnimeDetail(
      thumb: json['thumb'],
      sinopsis:
          json['sinopsis'] != null ? List<String>.from(json['sinopsis']) : [],
      detail: json['detail'] != null ? List<String>.from(json['detail']) : [],
      title: json['title'],
    );
  }
}

class Episode {
  final String episodeTitle;
  final String episodeEndpoint;
  final String episodeDate;

  Episode({
    required this.episodeTitle,
    required this.episodeEndpoint,
    required this.episodeDate,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeTitle: json['episode_title'],
      episodeEndpoint: json['episode_endpoint'],
      episodeDate: json['episode_date'],
    );
  }
}
