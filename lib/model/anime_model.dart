class Anime {
  final String id;
  final String title;
  final String posterImage;
  final int? episodeCount;
  final String? averageRating;
  final String? synopsis;
  final String? youtubeId;

  Anime(
      {required this.id,
      required this.title,
      required this.posterImage,
      this.episodeCount,
      this.averageRating,
      this.synopsis,
      this.youtubeId
      });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
        id: json['id'] as String,
        title: json['attributes']['canonicalTitle'] as String,
        posterImage: json['attributes']['posterImage']['medium'] as String,
        episodeCount: json['attributes']['episodeCount'] as int?,
        averageRating: json['attributes']['averageRating'] as String?,
        synopsis: json['attributes']['synopsis'] as String?,
        youtubeId: json['attributes']['youtubeVideoId'] as String?
        );
  }
}
